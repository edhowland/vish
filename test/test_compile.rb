# test_compile.rb - class TestCompile < BaseSpike

require_relative 'test_helper'

class TestCompile < BaseSpike
  include CompileHelper

  def set_up
    @parser, @transform = parser_transformer
#    @result = ''
  end



  # start of tests:
  def test_can_raise_parslet_parse_failed_for_leading_digit_in_identifier
    assert_raises Parslet::ParseFailed do
      bc, ctx = compile '0jkl=1'
    end
  end
  def test_proper_identifier_does_not_raise_parslet_parse_failed_exception
    bc, ctx = compile '_name=1'
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
    assert_eq ci.run, 1
  end
  def test_compile_add_expr
    bc, ctx = compile '4 + 6'
    ci = mkci bc, ctx
    assert_eq ci.run, 10
  end
  def test_sub
    bc, ctx = compile '6 -3'
    ci = mkci bc, ctx
    assert_eq ci.run, 3
  end
  def test_mult
    bc, ctx = compile '15 *3'
    ci = mkci bc, ctx
    assert_eq ci.run, 45
  end
  def test_div
    bc, ctx = compile '99/33'
    ci = mkci bc, ctx
    assert_eq ci.run, 3
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
    assert_eq ci.run, 99
  end
  def test_2_statements_w_semicolon_delim
    bc,ctx = compile('name=1;:name') 
    ci = mkci bc, ctx
    assert_eq ci.run, 1
  end
  def test_compile_multi_line_string
    bc, ctx = compile "1\n1"
  end
  def test_multi_line_full_expression
    bc, ctx = compile "var=2 * 4;pos=5 + :var\n:pos"
    ci = mkci bc, ctx;
    assert_eq ci.run, 13
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
    assert ci.run
  end
  def test_equality_is_false
    bc, ctx = compile 'val=5*5;:val == 44'
    ci = mkci bc, ctx
    assert_false ci.run
  end
  def test_inequality_is_true
    bc, ctx = compile '5 != 6'
    ci = mkci bc,ctx
    assert ci.run
  end
  def test_inequality_is_false_when_operands_match
    bc, ctx = compile   'name=100;vam=25*4;:name != :vam'

    ci = mkci bc, ctx
    assert_false ci.run
  end

  # leading space check
  def test_compile_leading_space
        bc, ctx = compile ' 1 + 2'
  end

  # ! negation
  def test_negation_returns_true
    bc, ctx = compile '! (1 == 2)'
    ci = mkci bc, ctx
    assert ci.run
  end
  def test_negation_returns_false
    bc, ctx = compile '!(1 == 1)'
    ci = mkci bc, ctx
    assert_false ci.run
  end
  def test_empty_can_compile
    bc, ctx = compile ''
  end
  def test_just_whitspace_can_compile
    bc, ctx = compile '         ' # many spaces
  end
  def test_empty_returns_only_program_start_and_ignore_and_then_finish_in_ast
    ir = @parser.parse ''
    ast = @transform.apply ir
    assert_eq ast.length, 2
  end

  # operator precedence
  def test_multiplaction_before_addition
    bc, ctx = compile '4+3*10'
    ci = mkci bc,ctx
    assert_eq ci.run, 34
  end
  def test_reversed_mult_before_additionmethod
    bc, ctx = compile '3*10+4'
    ci = mkci bc, ctx
    assert_eq ci.run, 34
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
    assert_eq ci.run, 1
  end
  def test_paren_plus_expression
    bc, ctx = compile '(1+2)'
    ci = mkci bc,ctx
    assert_eq ci.run, 3
  end
  def test_paren_mult_expression
    bc, ctx = compile '(4*4)'
    ci = mkci bc,ctx
    assert_eq ci.run, 16
  end
  def test_paren_w_2_plus
    bc, ctx = compile '(1+2)+3'
    ci = mkci bc, ctx
    assert_eq ci.run, 6
  end
  def test_paren_with_mult_w_another_additive_term
    bc, ctx = compile '(4*4)+4'
    ci = mkci bc, ctx
    assert_eq ci.run, 20
  end

  # modulo, Exponentiation
  def test_modulo
    bc, ctx = compile '8 % 2'
    ci = mkci bc, ctx
    assert ci.run.zero?
  end
def test_raise_to_power
  bc, ctx = compile '2**2'
  ci = mkci bc, ctx
  assert_eq ci.run, 4
end

  # test boolean literals: true, false
  def test_boolean_parses_true_string
    bc, ctx = compile 'true'
    ci = mkci bc, ctx
    assert ci.run
  end
  def test_boolean_compiles_false_keyword_as_false_class
    bc, ctx = compile 'false'
    ci = mkci bc, ctx
    assert_false ci.run
  end

  # Test boolean and, or and true, false. Note and, or are logical operators
  # with the lowest precedence even then ==, !=.
  # Not to be confused with &&, || which are statement separators.
  def test_and_simple
  bc, ctx = compile 'true and false'
    ci = mkci bc, ctx
    assert_false ci.run
  end
  def test_or_simple
  bc, ctx = compile 'false or true'
  ci = mkci bc, ctx
  assert ci.run
  end
def test_complex_operation_w_and_equality
  assert_false interpret 'false and 22 == 11 * 2'
end
def test_complex_or_w_inequality
  assert interpret 'false or 100 * 4 != 99'
end

  # test various things as rvalues in expressions
  def test_additon_w_funcall
#    assert_eq "helloworld\n", interpret("'hello' + echo('world')")
  end
  def  test_expression_can_have_funcall_as_rvalue
        bc, ctx = compile '44 - add(2)'
  end
  def test_expressions_can_stretch_past_newlines
    result = interpret "1 +    \n1\n"
  end
end
