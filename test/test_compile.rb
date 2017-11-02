# test_compile.rb - class TestCompile < BaseSpike

require_relative 'test_helper'

class TestCompile < BaseSpike
  def set_up
    @parser = VishParser.new
    @transform = AstTransform.new
    @result = ''
#    @stdout = $stdout
#    $stdout = StringIO.new
  end
  def tear_down
#    $stdout = @stdout
  end
  def compile string
    ir = @parser.parse string
    ast = @transform.apply ir
    emit_walker ast
  end
  def mkci bc, ctx
    CodeInterperter.new(bc, ctx) {|_bc, _ctx, bcodes| bcodes[:print] = ->(bc, ctx) { @result = ctx.stack.pop } }
  end
  def test_compile_1
    ir = @parser.parse '1'
    ast = @transform.apply ir
    bc, ctx = emit_walker ast
    assert_false bc.codes.empty?
  end
  def test_compile_and_run_1
    bc, ctx = compile('1')
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 1
  end
  def test_compile_add_expr
    bc, ctx = compile '4 + 6'
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 10
  end
  def test_sub
    bc, ctx = compile '6 -3'
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 3
  end
  def test_mult
    bc, ctx = compile '15 *3'
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 45
  end
  def test_div
    bc, ctx = compile '99/33'
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 3
  end
  def test_assign_value_to_var
    bc, ctx = compile 'name=5'
    ci = mkci bc, ctx
    ci.run

    assert_eq ctx.vars[:name], 5
  end
  def test_complex_assign_w_expr
    bc, ctx = compile 'var=4+5'
    ci = mkci bc, ctx
    ci.run
    assert_eq ctx.vars[:var], 9
  end
  def test_dereference_named_varaiable
    skip 'Need to complete parser rules and ast transform fo this'
    bc, ctx = compile ':name'
    ci = mkci bc,ctx
    ctx.vars[:name] = 99
    ci.run
  end
end