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
  include TreeUtils

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
  # simplest tail call
  def test_simplest_tail_call_is_converted
    tcompile 'defn f() {%f}'
    tails_found = 0
    visit_tree @tc.ast, tailcall: ->(x) { tails_found += 1}
    assert_eq tails_found, 1
  end
  def test_non_tc_optimized_compiler_does_not_transform_lambdacallls
        vcompile 'defn f() {%f}'
    tails_found = 0
    visit_tree @vc.ast, tailcall: ->(x) { tails_found += 1}
        assert tails_found.zero?, "Expected to not find any tail calls, but found #{tails_found} instead" 
  end
  def test_fact_direct_works_for_normal
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
    assert (vi.run == 9) && (ti.run == 9), "Expected both optimized and non_optiized to return9, but one of them did not"
  end
  def test_return_with_work_left_to_do_will_not_tail_call
    src = 'defn foo() { return 8 + %g}'
    tails_found = 0
    tcompile src
    visit_tree @tc.ast, tailcall: ->(x) { tails_found += 1 }
    assert tails_found.zero?, "Expected to not find any tail calls because work left to do, but found #{tails_found}"
  end
  def test_return_via_block_withtail_call_is_tail_call
    src = 'defn foo() { return {9; %g}}'
    tcompile src
    tails_found = 0
        visit_tree @tc.ast, tailcall: ->(x) { tails_found += 1 }
    assert_eq tails_found, 1
  end
  # Should tail call within non-lambda bodies E.g. top-level blocks, conditionals
  def test_does_not_convert_lambdacalls_to_tailcalls_for_top_level_constructs
    tcompile 'defn g() {9}; {1; %g}'
    tail_found = false
    lambdacall_found = false
    visit_tree @tc.ast, lambdacall: ->(x) { lambdacall_found = true }, tailcall: ->(x) { tail_found = true }
    assert !tail_found, "Expected to not find any :tailcalls, but did"
    assert lambdacall_found, "Expected to find a :lambdacall node"
  end
  # Should not have any tail calls for top-level conditionals, either.
  def test_top_level_conditionals_should_not_have_tail_calls
    tcompile 'zero?(0) && %g'
      tail_found = false
    lambdacall_found = false
    visit_tree @tc.ast, lambdacall: ->(x) { lambdacall_found = true }, tailcall: ->(x) { tail_found = true }
    assert !tail_found, "Expected to not find any :tailcalls, but did"
    assert lambdacall_found, "Expected to find a :lambdacall node"  
  end

  # Cannot have tail calls in blocks that are not the tail position inside 
  # lambdas. Must refrain from promoting anything in block or conditional
  # into tailcall.
  def test_non_tail_position_blocks_cannot_have_tailcalls
    tails_found = 0
    tcompile 'defn foo() {{9; %g}; 99}'
    visit_tree @tc.ast, tailcall:->(x) {tails_found += 1 }
    assert tails_found.zero?, "Expected to not find any tail calls, but found #{tails_found} instead" 
  end
  def test_block_at_tail_position_will_still_be_checked_for_tail_call
    tcompile 'defn foo() {1; {9;%g}}'
    tails_found = 0
    visit_tree @tc.ast, tailcall: ->(x) { tails_found += 1 }
    assert_eq tails_found, 1
  end
  def test_conditionals_not_tail_position_cannot_have_tail_calls
    tails_found = 0

    tcompile 'defn foo() { zero?(0) && %g; 3}'
    visit_tree @tc.ast, tailcall:->(x) {tails_found += 1 }
    assert tails_found.zero?, "Expected to not find any tail calls, but found #{tails_found} instead" 
  end
  end
  