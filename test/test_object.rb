# test_object.rb - tests for simple object ctors w/closures

require_relative 'test_helper'

class TestObject < BaseSpike
  include CompileHelper
  def set_up
#    @lib = 'defn mkattr(k,v) {  s=mksym("set_:{:k}");  mkobject(mkpair(:k, ->() { :v }), mkpair(:s, ->(x) { v=:x; :v })) };'
    @lib =<<-EOD
# std/lib.vs - Vish Standard Library functions
# mkarr - creates object for use of  in object construction
# Usage: obj=mkarr(foo:, 2)
defn mkattr(k,v) {
  s=mksym("%{:k}!")
  mkobject(mkpair(:k, ->() { :v }), mkpair(:s, ->(x) { v=:x; :v }))
}
defn keys(obj) { xmit(:obj, keys:) }
defn values(obj) { xmit(:obj, values:) }

# list helpers
defn car(l) { key(:l) }
defn cdr(l) { value(:l) }
defn cadr(l) { car(cdr(:l)) }
defn cddr(l) { cdr(cdr(:l)) }
defn caddr(l) { car(cddr(:l)) }
defn cdddr(l) { cdr(cddr(:l)) }

defn list_length(l) {
  null?(:l) && return 0
  1 + list_length(cdr(:l))
}
# set up some variables
null=mknull()
version=version()
# Can check the current dir with %pwd
pwd=->() { pwd() }
EOD
  end
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

  # test can send various argument lists to lambda in object
  def test_can_send_0_args_to_method_call
    result = interpret 'm=~{foo: ->() { 99 }};%m.foo()'
    assert_eq result, 99
  end
  def test_can_send_1_argument_to_method
    result=interpret 'o=~{add1: ->(x) { :x + 1 }};%o.add1(4)'
    assert_eq result, 5
  end
  def test_can_send_multiple_args_to_method
    result=interpret 'l=~{many: ->(a, b, c) { :a * :c + :b }};%l.many(1,2,3)'
    assert_eq result, 5
  end

  # test piping of output to another fn
  def test_can_pipe_output_to_another_fn
    result = interpret @lib + 'x=mkattr(foo:, 2); %x.foo | dup()'
    assert_eq result, 2
  end
  def test_can_pipe_method_dispatch_to_fn
    result = interpret 'x=~{foo: 2};:x.foo | dup()'
    assert_eq result, 2
  end
  def test_can_accept_input_from_another_fn_over_a_pipe
    result = interpret @lib + 'x=mkattr(foo:, 1); 3 | %x.foo!; %x.foo'
    assert_eq result, 3
  end
  def test_can_use_method_call_in_logical_and_expression
    result = interpret @lib + 'x=mkattr(foo:, true); %x.foo && true'
    assert result
  end
  def test_can_use_method_dereference_in_logical_or
    result = interpret 'x=~{foo: false};:x.foo || true'
    assert result
  end

  # test method calls can take function parameters
  def test_method_calls_can_take_and_execute_fn_parm
    result = interpret 'a=~{foo: ->(fn) { %fn }};%a.foo(->() {4})'
    assert_eq result, 4
  end
  # test assign value to object with indexed assignment: o[foo:]=100
  def test_can_assign_to_object_with_subscript_deref
    result = interpret 'o=~{one: 1, two: 2, three: 3};o[two:]=22;:o[two:]'
    assert_eq result, 22
  end
end
