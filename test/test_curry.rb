# test_curry.rb - tests for

require_relative 'test_helper'

class TestCurry < BaseSpike
  include CompileHelper
  def test_curried_function_is_unchanged_with_equal_arity_count
    r = interpret 'defn foo(a, b) { :a + :b};c=curry(:foo);c(3,4)'
    assert_eq r, 7
  end
end
