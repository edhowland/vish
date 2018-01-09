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

  # test builtin setting of object within list
  def test_ax_sets_value_in_listmethod
    result = interpertit 'a=[5,6,7];ax(:a,2,100);:a'
    assert_eq result, [5,6,100]
  end

  # the way to append an item or many items to a list
  def test_append_1_item_to_list
    result = interpertit 'l=[1,22,333,4444];l=list(:l,55555);:l'
    assert_eq result, [1,22,333,4444,55555]
  end
  def test_appand_many_lists_into_one
    result = interpertit 'l=list([1],[2,3],[4,5,6],[7,8,9,10]);:l'
    assert_eq result, [1,2,3,4,5,6,7,8,9,10]
  end
end