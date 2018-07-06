# test_curry.rb - tests for

require_relative 'test_helper'

class TestCurry < BaseSpike
  include CompileHelper
  def test_curried_function_is_unchanged_with_equal_arity_count
    r = interpret 'defn foo(a, b) { :a + :b};c=curry(:foo);c(3,4)'
    assert_eq r, 7
  end
  def test_curry_function_with_arity_2_returns_new_curry_function_w_1_arg
    result = interpret 'defn foo(a, b) {:a + :b};c=curry(:foo);c(3)'
    assert_is result, CurryFunction
  end
  def test_curry_w_2_arity_when_called_returns_correct_answer_w_2_args
    result = interpret 'defn foo(a, b) {:a + :b};c=curry(:foo);c(4,6)'
    assert_eq result, 10
  end
  def test_curry_w_2_arity_2nd_fn_called_w_1_arg_returns_correct_result
    result = interpret 'defn foo(a, b) {:a + :b};c=curry(:foo);c1=c(4);c1(6)'
        assert_eq result, 10
  end
  def test_curry_w_3_arity_gets_called_when_chained_with_3_sep_calls
    result = interpret 'defn bar(a, b, c) {:a + :b + :c};c=curry(:bar);c1=c(1);c2=c1(2);c2(3)'
    assert_eq result, 6
  end
  def test_curry_w_3_called_w_2_then_1
    result = interpret 'defn foo(a,b,c) {:a+:b+:c};c=curry(:foo);c1=c(1,2);c1(3)'
    assert_eq result, 6
  end
end
