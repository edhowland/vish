# test_branch.rb - tests for conditional branching

require_relative 'test_helper'

class TestBranch < BaseSpike
  include CompileHelper
  
  def set_up
    @parser, @transform = parser_transformer
  end
  def test_conditional_and_runs_both_statements
    bc, ctx = compile 'true && name=99; :name'
    ci=mkci bc, ctx
    assert_eq ci.run, 99
  end
  def test_conditional_and_does_not_run_second_statement
    bc, ctx = compile 'name=0; false && name=99; :name'
    ci = mkci bc, ctx
    assert ci.run.zero?
  end
  # conditional or
  def test_conditional_or_runs_both_statement_if_first_statement_is_false
    bc, ctx = compile 'false || name=99; :name'
    ci = mkci bc, ctx
    assert_eq ci.run, 99
  end
  def test_conditional_or_does_not_run_second_statement_if_first_statement_is_true
    assert interpertit('name=0; true || name=99; :name').zero?
  end

  # complicated compound multi tests
  def test_compound_branch_w_3_terms_t_t_assign
    assert interpertit('var=0; true && true || var=99; :var').zero?
  end
  def test_compound_with_or_does_do_the_assignment
    assert_eq  interpertit( 'sam=0; false || true && sam=99; :sam'), 99
  end

  # testing and then executing
  def test_equality_w_and_echo
    assert_eq interpertit("var=33; :var == 33 && echo('ok')"),"ok\n" 
  end
  def test_inequality_with_or_runs_final_term
    assert_eq interpertit("var=99; :var != 99 || echo('ok')"),"ok\n"
  end
end