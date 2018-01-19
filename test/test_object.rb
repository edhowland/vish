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
end