# test_lambda.rb - tests for  lambdas.

require_relative 'test_helper'

class TestLambda < BaseSpike
  include CompileHelper

  # test order of arguments in lambda call
  def test_order_of_arguments_as_actual_values_in_lambda_body
    result = interpret 'sub=->(a, b) { :a - :b };%sub(9,3)'
    assert_eq result, 6
  end

  # correct value is being returned
  def test_no_argument_case
    result = interpret 'one=->(a) { true };%one(1)'
    assert result
  end

  # overconsumption/underproduction of arguments to function
  def test_under_production_over_consumption_of_arguments
    assert_raises VishArgumentError do
      result = interpret 'low=->(f, g) { 1 };%low()'
    end
  end
  def test_can_call_with_no_arguments
    result = interpret 'jj=->() { 99 };%jj()'
    assert_eq result, 99
  end
  def test_identity_lambda
    result=interpret 'id=->(a) { :a };%id("hello")'
    assert_eq result, 'hello'
  end

  # check for unknown lambdas
  def test_unknonw_lambda_raises_lambda_not_found
    assert_raises LambdaNotFound do
      interpret '%bk()'
    end

  end


  # test return within lambda
  def test_returnfrom_lambda
    result = interpret 'lm=->() { return 99; 2 };%lm()'
    assert_eq result, 99
  end

  # test parsing lambdas used as terms in larger expression
  def test_can_parse_add_lambda_term
    p, = parser_transformer
    p.parse '%p() + 1'
  end

  # test lambda and blocks interchangeability
  def test_4_mix_of_lambdas_and_blocks_can_call_each_other
    result = interpret <<EOC
l1=->() {1}
b1=:{%l1()}
l2=->() {%b1}
m2=:{%l2}
%m2
EOC
    assert_eq result, 1
  end

  # test that can execute lambda in list that indexed via function return
  def test_can_call_lambda_in_list_indexed_w_fn_return
    result = interpret 'defn foo() {0}; a=[->() {9}]; %a[foo()]'
    assert_eq result, 9
  end
  def test_can_call_lambda_indexed_with_lambda_call_return
    result = interpret 'fn=->() {0};a=[->() {9}];%a[%fn]'
    assert_eq result, 9
  end
  # test object dereference. From test_object, but with list[symbol:]
  def test_can_call_lambda_w_symbol_derefed_in_object
    result = interpret 'a=~{foo: ->() {9}};%a[foo:]'
    assert_eq result, 9
  end
  # try passing 0, 1, 2 args to indexed lambda_call in list:
  def test_can_pass_0_args_to_indexed_lambda
    result = interpret 'a=[->() {9}];%a[0]()'
    assert_eq result, 9
  end
  def test_can_pass_1_arg_to_lambda_deref_from_list_index
    result = interpret 'a=[->(x) {:x}];%a[0](9)'
    assert_eq result, 9
  end
  def test_can_pass_2_args_to_lambda_derefed_from_list_index
    result = interpret 'a=[->(x, y) { :x + :y }];%a[0](1,2)'
    assert_eq result, 3
  end

  # can we pass a lambda to an indexed lambda in a list, or an object vis
  # thedotted  call method?
  def test_can_pass_a_lambda_to_lambda_indexed_in_a_list
    result = interpret <<-EOC
a=~{callme: ->(fn) { %fn }}
%a[callme:](->() {4})
EOC
      assert_eq result, 4
  end
  def test_can_pass_lambda_via_dotted_method_call
    result = interpret <<-EOC
a=~{frak: ->(fn) { %fn }}
%a.frak(->() {5})
EOC
    assert_eq result, 5
  end
  def test_can_pass_argument_to_lambda_passed_to_lambda_indexed_in_list
    result = interpret <<-EOC
a=~{foo: ->(fn) { %fn(4) }}
%a[foo:](->(x) { :x + 2 })
EOC
    assert_eq result, 6
  end
  def test_can_pass_arg_to_lambda_passed_to_lambda_indexed_in_object_w_dotted_method_call
    result = interpret <<-EOC
a=~{bar: ->(fn) { %fn(10) }}
%a.bar(->(x) { :x - 1})
EOC
    assert_eq result, 9
  end
  # Make sure the same lambda has the same loc in bytecode even if created twice
  def test_lambda_retains_its_location_in_bytecode
    result = interpret 'defn foo() { ->() {} }; [%foo, %foo]'
    assert_eq result.first[:loc], result.last[:loc]
  end
  def test_frame_from_has_dupped_binding
    l = interpret 'defn foo() { a=9}'
    fr = l.frame_from
    assert_eq fr.ctx.vars.class, BindingType
  end
end
