# test_evaluator.rb - tests for Evaluator class

require_relative 'test_helper'

class TestEvaluator < BaseSpike
  include CompileHelper
  def set_up
    @eval = Evaluator.new
  end
  def test_eval_string_returns_correct_anaswer
    result = @eval.eval 'defn foo() {true};foo()'
    assert result
  end
  def test_on_second_pass_calls_back_referenced_function
    @eval.eval 'defn foo() {99}'
    result = @eval.eval 'foo()'
    assert_eq result, 99
  end
  def test_third_pass
    @eval.eval 'defn foo() { 100 }'
    @eval.eval 'defn bar(x) { :x / 2 }'
    result = @eval.eval 'bar(foo())'
    assert_eq result, 50
  end
end