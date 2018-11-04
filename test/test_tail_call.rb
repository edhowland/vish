# test_tail_call.rb - tests for tail call optimization

require_relative 'test_helper'


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
  def cifrom(compiler)
    CodeInterpreter.new(compiler.bc, compiler.ctx)
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
    @vc.default_optimizers[:tail_call] = true
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
  end
  