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
end