# test_function.rb - tests for Function

require_relative 'test_helper'

class TestFunction < BaseSpike
  include CompileHelper
  def test_actually_calls_function
    result = interpertit 'defn foo() {true};foo()'
    assert result
  end
end