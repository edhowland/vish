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
    bc, ctx = compile ':name'
    ci = mkci bc,ctx
    ctx.vars[:name] = 99
    ci.run
    assert_eq @result, 99
  end
  def test_2_statements_w_semicolon_delim
    bc,ctx = compile('name=1;:name') 
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 1
  end
  def test_compile_multi_line_string
    bc, ctx = compile "1\n1"
  end
  def test_multi_line_full_expression
    bc, ctx = compile "var=2 * 4;pos=5 + :var\n:pos"
    ci = mkci bc, ctx;
    ci.run
    assert_eq @result, 13
  end
  def test_comment
    cmp = VishParser.new
    cmp.comment.parse "# \n"
  end
  def test_comment_w_stuff
    cmp = VishParser.new
    cmp.comment.parse "# some awful Stuff!!&&@@[]dj .>?<\n"
  end
  def test_compile_w_o_newline
        cmp = VishParser.new
    cmp.comment.parse '# comment'
  end
  def test_comment_w_expression
    bc, ctx = compile "name=4*3# come\n:name\n"
    ci = mkci bc, ctx
    ci.run
    assert_eq ctx.vars[:name], 12
  end
  def test_compile_arith_expr_beginning_w_deref
    bc, ctx = compile 'name=1;:name+4'
  end

  def test_can_match_complex_identifiers
    @parser.identifier.parse 'nname001'
  end
end