# test_closure.rb - tests for lambda closures

require_relative 'test_helper'

class TestClosure < BaseSpike
  include CompileHelper
  def test_closure_remembers_state_of_var
    result = interpret 'z=99;lm=->() { :z };%lm()'
    assert_eq result, 99
  end
  def test_closure_changes_as_closed_var_changes
    result = interpret 'z=88; lm=->() { :z }; x=%lm(); z=99;list(:x, %lm())'
    assert_eq result, [88,99]
  end

  # functions returning lambdas
  def test_function_returns_lambda_closing_over_parameter
    result = interpret 'defn bar(f) { ->() { :f + 1 } };add1=bar(9);add2=bar(4);%add1() * %add2()'
    assert_eq result, 50
  end
  def test_internal_lambda_vars_are_not_unbound
    result = interpret 'lm=->() { y=10; :y };%lm()'
    assert_eq result, 10
  end

  # test for actual unbound variables that do not have matching closures
  def test_unbound_variables_return_undefined
      result = interpret 'fn=->() { :p }; %fn()'
      assert_eq result, Undefined
  end

  # test mix of closures, parameters and local variables
  def test_mix_of_closures_locals_and_parameters
    result = interpret 'y=10;fn=->(x) { z=4; :x * :y + :z };%fn(3)'
    assert_eq result, 34
  end

  # test closures over inner lambda from outer lambda
  def test_closures_work_from_within_another_closure
    result = interpret 'm=->(x) { ->() { :x + 1 } };y=%m(2);%y()'
    assert_eq result, 3
  end
  def test_inner_lambda_closes_over_outer_lambda
    source =<<-EOC
defn ml(x) {
  ->(y) {
    ->() { :x + :y }
  }
}
l1=ml(2); l2=%l1(3)
%l2()
EOC
    result = interpret source
    assert_eq result, 5
  end

  # test for setting closed over external variables
  def test_lambda_can_set_closed_over_term
    result = interpret 'x=9;m=->() { x=10 };%m();:x'
    assert_eq result, 10
  end

  # test for mix of lexical closures and shadowed parameters
  def test_can_mix_shadowed_variables_and_outer_bound_vars
    result = interpret 'a=1;b=2;c=3;f=->(a, b) { [:a, :b, :c]};%f(9,8)'
    assert_eq result, [9,8,3]
  end
  def test_multiple_nesting_of_closures
    result = interpret 'a=9;c=33;defn foo(a) {->(b) {->() { [:a, :b, :c]}}};x=foo(44);z=%x(66);%z'
    assert_eq result, [44, 66, 33]
  end
end
