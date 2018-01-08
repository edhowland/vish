# test_lambda.rb - tests for  lambdas.

require_relative 'test_helper'

class TestLambda < BaseSpike
  include CompileHelper

  # test order of arguments in lambda call
  def test_order_of_arguments_as_actual_values_in_lambda_body
    result = interpertit 'sub=->(a, b) { :a - :b };%sub(9,3)'
    assert_eq result, 6
  end

  # correct value is being returned
  def test_no_argument_case
    result = interpertit 'one=->(a) { true };%one(1)'
    assert result
  end

  # overconsumption/underproduction of arguments to function
  def test_under_production_over_consumption_of_arguments
    assert_raises ArgumentError do
      result = interpertit 'low=->(f, g) { 1 };%low()'
    end
  end
  def test_can_call_with_no_arguments
    result = interpertit 'jj=->() { 99 };%jj()'
    assert_eq result, 99
  end
  def test_identity_lambda
    result=interpertit 'id=->(a) { :a };%id("hello")'
    assert_eq result, 'hello'
  end

  # check for unknown lambdas
  def test_unknonw_lambda_raises_lambda_not_found
    assert_raises LambdaNotFound do
      interpertit '%bk()'
    end

  end


  # test return within lambda
  def test_returnfrom_lambda
    result = interpertit 'lm=->() { return 99; 2 };%lm()'
    assert_eq result, 99
  end

  # test parsing lambdas used as terms in larger expression
  def test_can_parse_add_lambda_term
    p, = parser_transformer
    p.parse '%p() + 1'
  end
end
