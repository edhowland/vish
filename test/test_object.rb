# test_object.rb - tests for simple object ctors w/closures

require_relative 'test_helper'

class TestObject < BaseSpike
  include CompileHelper
  def test_simple_object_ctor_with_2_attr_readers
    result = interpret 'defn ctor(x,y) { [->() { :x },->() { :y }] };obj=ctor(7,8);mx=ix(:obj,0);my=ix(:obj,1);%mx() + %my()'
    assert_eq result, 15
  end
  def test_can_index_object_w_symbol
    result = interpret 'd=dict(thing:,7,that:,3);:d[that:]'
    assert_eq result, 3
  end
  # test executation of lambda value in object
  def test_can_call_symbol_indexed_lambda_in_object
    result = interpret 'obj=dict(foo:, ->() {66*10});%obj[foo:]'
    assert_eq result, 660
  end

  # can deref dict element be first term in expression?
  def test_can_deref_element_in_dict_be_first_term_in_expression
    result = interpret 'd=dict(foo:,99);:d[foo:] + 1'
    assert_eq result, 100
  end
  def test_can_execute_lambda_value_as_first_term_in_expression
    result = interpret 'd=dict(bar:,->() {3});%d[bar:] + 4'
    assert_eq result, 7
  end
  def test_canhave_expression_with_2_dict_derefs
    result = interpret 'd=dict(one:,1,two:,2);:d[one:] + :d[two:]'
    assert_eq result, 3
  end

  # test method calls
  def test_can_call_method_w_dot_syntax
    result = interpret 'm=dict(foo:,->() {66});%m.foo'
    assert_eq result, 66
  end

  # test PairType
  def test_can_make_pair
    result = interpret 'foo: 2'
    assert_is result, PairType
  end
  def test_pair_type_has_key
    ptype = interpret 'bar: 3'
    assert_eq ptype.key, :bar
  end
  def test_pair_type_has_value
    ptype = interpret 'baz: 4'
    assert_eq ptype.value, 4
  end

  # test mkobject builtin
  def test_mkobject_can_be_created
    otype = interpret 'mkobject()'
    assert_is otype, ObjectType
  end
  def test_mkobject_can_take_1_pair_type
    otype = interpret 'mkobject(foo: 2)'
    assert_eq otype, {:foo => 2}
  end
  def test_mkobject_can_take_multiple_pair_types
    otype = interpret 'mkobject(foo: 1, bar: 2, baz: 3)'
    assert_eq otype, {:foo => 1, :bar => 2, :baz => 3}
  end
  def test_mkobject_raises_pair_illegal_argument_when_not_given_pair_types
    assert_raises  PairInvalidArgumentType do
      interpret 'mkobject(1, 2)'
    end
  end

  # test can create objects with ~{} syntax
  def test_can_create_object_type_with_tilde_syntax
    otype = interpret '~{}'
    assert_is otype, ObjectType
  end

  # test objects in expressions
  def test_can_add_2_objects
    result = interpret '~{foo: 1,bar: 2} + ~{baz: 3, qxy: 4}'
    assert_eq result, {:foo => 1, :bar => 2, :baz => 3, :qxy => 4}
  end
  def test_can_construct_object_with_single_pair
    result = interpret '~{foo: 1}'
    assert_eq result, {:foo => 1 }
  end

  # test can expose instance var via dotted method:
  def test_can_access_internal_value_via_dotted_method
    result = interpret 'foo=~{var: 66};:foo.var'
    assert_eq result, 66
  end
end
