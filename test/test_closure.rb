# test_closure.rb - tests for lambda closures

require_relative 'test_helper'

class TestClosure < BaseSpike
  include CompileHelper
  def test_closure_remembers_state_of_var
    result = interpertit 'z=99;lm=->() { :z };%lm()'
    assert_eq result, 99
  end
  def test_closure_changes_as_closed_var_changes
    result = interpertit 'z=88; lm=->() { :z }; x=%lm(); z=99;list(:x, %lm())'
    assert_eq result, [88,99]
  end

  # functions returning lambdas
  def test_function_returns_lambda_closing_over_parameter
    result = interpertit 'defn bar(f) { ->() { :f + 1 } };add1=bar(9);add2=bar(4);%add1() * %add2()'
    assert_eq result, 50
  end
  def test_internal_lambda_vars_are_not_unbound
    result = interpertit 'lm=->() { y=10; :y };%lm()'
    assert_eq result, 10
  end

  # test for actual unbound variables that do not have matching closures
  def test_unbound_variables_raise_undefined_variable_error
    assert_raises UndefinedVariable do
      interpertit 'fn=->() { :p }; %fn()'
    end
  end
end