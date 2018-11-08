# test_tail_call.rb - tests for tail call optimization

require_relative 'test_helper'

## NOTE:
# Since old CodeInterpreter does not support multiple instances of itself,
# we use instead prototype of VishMachine(Ex) instead. This allows us to compare
# the results of a non-tail call optimized compiler with a tail call optimized
# one.
require_relative '../lib/vm'


class TestTailCall < BaseSpike
  include CompileHelper

def src_fact_direct
      <<-EOC
    # fact-direct.vs - Direct method of factorial
defn fact(n) {
  {zero?(:n) && 1} || :n * fact(:n - 1)
}
fact(5)
EOC
end

def src_fact_aps
  <<-EOC
  # fact-aps.vs - Factorial using accumulator passing style
defn fact(n) {
defn fact_aps(x, acc) {
  {zero?(:x) && :acc} || fact_aps(:x - 1, :acc * :x)
}

  # Now call helper
  fact_aps(:n, 1)
}
fact(6)
EOC
end
  def cifrom(compiler)
    result = VishMachineEx.new(compiler.bc, compiler.ctx)
    VishPrelude.build result
    result
  end
  def vcompile source
    @vc.source = source
    @vc.run
    @vc
  end
  def tcompile source
    @tc.source = source
    @tc.run
    @tc
  end

  def mkvi(source)
    cifrom(vcompile(source))
  end
  def mkti(source)
    cifrom(tcompile(source))
  end

  def set_up
    @vc = VishCompiler.new
    @tc = VishCompiler.new
    @tc.default_optimizers[:tail_call] = true
  end

  def test_simple_block_returns_match
    source = '{1+2}'
    vcompile source; tcompile source

    vi = cifrom @vc; ti = cifrom @tc
    assert_eq ti.run, vi.run
  end
  def test_function_return_wo_pass_into_function
    source = 'defn g() { 99 };defn f() { return %g; 0}; %f'
    vi=cifrom(vcompile(source))
    assert_eq vi.run, 99
  end
  def test_fib_direct_works_for_normal
    vi = mkvi src_fact_direct
    result = vi.run
    assert_eq result, 120
  end
  def test_fact_direct_works_for_tail_optimized
    ti = mkti src_fact_direct
    result = ti.run
    assert_eq result, 120
  end
  def test_fact_direct_both_get_same_result
    vi = mkvi src_fact_direct; ti = mkti src_fact_direct
    assert_eq ti.run, vi.run
  end
  def test_fact_aps_both_agree
    vi = mkvi src_fact_aps; ti = mkti src_fact_aps
    assert_eq ti.run, vi.run
  end

  # Now capture maximum stack depth reached
  def max_depth &blk
    xmax =  0
    loop do
      begin
        xmax = [xmax, yield].max
      rescue HaltState
        raise StopIteration
      end
    end
    xmax
  end

  def test_fact_dir_matches_stack_depth
    vi = mkvi src_fact_direct; ti = mkti src_fact_direct
    vmax = max_depth { vi.step; vi.frames.length }
    tmax = max_depth { ti.step; ti.frames.length }
    assert_eq tmax, vmax
    # puts "vmax #{vmax}, tmax #{tmax}"
  end

  # Should not be same stack depth, must be smaller
  def test_fact_aps_should_result_smaller_max_depth_for_tail_call
    vi = mkvi src_fact_aps; ti = mkti src_fact_aps
    vmax = max_depth { vi.step; vi.frames.length }
    tmax = max_depth { ti.step; ti.frames.length }
    assert tmax < vmax, "Expected #{tmax} to be less than #{vmax}"
  end

  # simple block: TODO: Must handle top-level block
  def test_simple_block_will_tail_call
    src =<<-EOC
    defn t() {
      defn g() { 2;9}
      {3;%g}
    }
    %t
EOC
    vi = mkvi src; ti = mkti src
    vmax = max_depth { vi.step; vi.frames.length }
    tmax = max_depth { ti.step; ti.frames.length }

      assert tmax < vmax, "Expected #{tmax} to be less than #{vmax}"
  end

  # test return via tail call
  def test_will_return_via_tail_call
    src =<<-EOC
defn g() {9}
defn f(x) {
  zero?(:x) && return %g
  %g + 9
}

EOC
    vi = mkvi src+"\nf(0)\n";ti = mkti src+"\nf(0)\n"
  end
  end
  