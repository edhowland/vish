# test_object.rb - tests for simple object ctors w/closures

require_relative 'test_helper'

class TestObject < BaseSpike
  include CompileHelper
  def test_simple_object_ctor_with_2_attr_readers
    result = interpret 'defn ctor(x,y) { [->() { :x },->() { :y }] };obj=ctor(7,8);mx=ix(:obj,0);my=ix(:obj,1);%mx() + %my()'
    assert_eq result, 15
  end
end