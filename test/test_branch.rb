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
    ci.run
    assert_eq @result, 99
  end
  def test_conditional_and_does_not_run_second_statement
    bc, ctx = compile 'name=0; false && name=99; :name'
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 0
  end
  # conditional or
  def test_conditional_or_runs_both_statement_if_first_statement_is_false
    bc, ctx = compile 'false || name=99; :name'
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 99
  end
  def test_conditional_or_does_not_run_second_statement_if_first_statement_is_true
    bc, ctx = compile 'name=0; true || name=99; :name'
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 0
  end
  
  # complicated compound multi tests
  def test_compound_branch_w_3_terms_t_t_assign
    bc, ctx = compile 'var=0; true && true || var=99; :var'
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 0
  end
  def test_compound_with_or_does_do_the_assignment
    bc, ctx = compile 'sam=0; false || true && sam=99; :sam'
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 99
  end
end