# test_compile.rb - class TestCompile < BaseSpike

require_relative 'test_helper'

class TestCompile < BaseSpike
  def set_up
    @parser = VishParser.new
    @transform = AstTransform.new
    @result = ''
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
  # logical ops
  def test_equality_is_true
    bc, ctx = compile '1==1'
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, true
  end
  def test_equality_is_false
    bc, ctx = compile 'val=5*5;:val == 44'
    ci = mkci bc, ctx
    ci.run
    assert_false @result
  end
  def test_inequality_is_true
    bc, ctx = compile '5 != 6'
    ci = mkci bc,ctx
    ci.run
    assert @result
  end
  def test_inequality_is_false_when_operands_match
    bc, ctx = compile   'name=100;vam=25*4;:name != :vam'

    ci = mkci bc, ctx
    ci.run
    assert_false @result
  end
  
  # leading space check
  def test_compile_leading_space
        bc, ctx = compile ' 1 + 2'
  end

  # ! negation
  def test_negation_returns_true
    bc, ctx = compile '! 1 == 2'
    ci = mkci bc, ctx
    ci.run
    assert @result
  end
  def test_negation_returns_false
    bc, ctx = compile '! 1 == 1'
    ci = mkci bc, ctx
    ci.run
    assert_false  @result
  end
  def test_empty_can_compile
    bc, ctx = compile ''
  end
  def test_just_whitspace_can_compile
    bc, ctx = compile '         ' # many spaces
  end
  def test_empty_returns_only_program_start_finish_in_ast
    ir = @parser.parse ''
    ast = @transform.apply ir
    assert_eq ast.length, 2
  end

  # operator precedence
  def test_multiplaction_before_addition
    bc, ctx = compile '4+3*10'
    ci = mkci bc,ctx
    ci.run
    assert_eq @result, 34
  end
  def test_reversed_mult_before_additionmethod
    bc, ctx = compile '3*10+4'
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 34
  end

  def test_long_set_of_additive_expressions
    bc, ctx = compile '1+2+3'
  end
  def test_long_set_of_multiplicative_expressions
    bc,ctx = compile '1*1*1*1*1'
  end
  def test_multiplicative_rule_works
    bc, ctx = compile '3*10+11'
    
  end

  def test_multi_factor_w_deref_in_middle
    bc, ctx = compile '3+4*:name'
  end
  def test_deref_at_start_of_2_part_expression
    bc, ctx = compile ':name+2*3'
  end
  def test_deref_at_end_set_of_2_term_expression
    bc, ctx = compile '1*2+:name'
  end
  def test_many_derefs_in_2_term_expression
    bc, ctx = compile ':name+:var*:exp'
  end
  def test_deref_then_term_then_deref
    bc, ctx = compile ':name+4 * :var'
  end
  def test_term_deref_deref
    bc, ctx = compile '2+:name*:var'
  end
  def test_deref_deref_term
    bc, ctx = compile ':name+:var*2'
  end

  # test combinations of types, equality, assignment + arithmetic
  def test_equality_w_arithmetic
    bc, ctx = compile '4 == 2*2'
  end
  def test_assign_to_result_of_expression
    bc, ctx = compile 'name=4*12'
  end
  def test_assign_to_additive_then_multiplicative
    bc, ctx = compile 'var=1+2*3'
  end
  def test_inequality_w_expression
    bc, ctx = compile '4!=4*4'
  end

  def test_inequality_should_allow_expression_for_lvalue
    bc, ctx = compile '4*4 != 4'
  end
  def test_equality_should_allow_lvalue_to_be_an_additive_or_multiplicative
    bc, ctx = compile '1+2*2 == 100'
  end

  # simple parenthesis grouping
  def test_simple_paren_1_digit
    bc, ctx = compile '(1)'
    ci=mkci bc, ctx
    ci.run
    assert_eq @result, 1
  end
  def test_paren_plus_expression
    bc, ctx = compile '(1+2)'
    ci = mkci bc,ctx
    ci.run
    assert_eq @result, 3
  end
  def test_paren_mult_expression
    bc, ctx = compile '(4*4)'
    ci = mkci bc,ctx
    ci.run
    assert_eq @result, 16
  end
  def test_paren_w_2_plus
    bc, ctx = compile '(1+2)+3'
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 6
  end
  def test_paren_with_mult_w_another_additive_term
    bc, ctx = compile '(4*4)+4'
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 20
  end
end
