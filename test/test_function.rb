# test_function.rb - tests for Function

require_relative 'test_helper'

class TestFunction < BaseSpike
  include CompileHelper
  def test_actually_calls_function
    result = interpertit 'defn foo() {true};foo()'
    assert result
  end
  def test_recursive_call_with_parameter
    result = interpertit 'defn foo(x) { :x == 0 && return 0; foo(:x - 1) };foo(10)'
    assert_eq result, 0
  end
  def test_loop_can_break_from_within_lambda_within_function
    interpertit 'defn foo(fn) { %fn() }; loop { foo(->() { break }) }'
  end
  def test_function_can_return_lambda
    result = interpertit 'defn foo() { ->() {1} }'
  end
  def test_function_returns_lambda_which_be_called
    result = interpertit 'defn bar() { ->() {99} };fn=bar();%fn()'
    assert_eq result, 99
  end
  def test_lambda_can_call_user_function
    result = interpertit 'defn baz() { true };fn=->() { baz() };%fn()'
    assert result
  end
end