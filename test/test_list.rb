# test_list.rb - tests for list: [1,2,...n] expressions

require_relative 'test_helper'

class TestList < BaseSpike
  include CompileHelper
  def test_can_create_empty_list
    result = interpertit '[]'
    assert_eq result, []
  end
  def test_list_with_one_value
    result=interpertit '[9]'
    assert_eq result, [9]
  end
  def test_list_with_many_elements_can_be_assigned
    result = interpertit 'lt=[0,1,2,3,4,5];:lt'
    assert_eq result, [0,1,2,3,4,5]
  end

  # test list index
  def test_list_index_of_simple_list
    result = interpertit 'a=[99,98,97];:a[1]'
    assert_eq result, 98
  end
  def test_list_index_can_be_assigned
    result = interpertit 'm=[33,4,55];x=:m[1];:x'
    assert_eq result, 4
  end
end