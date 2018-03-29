# test_list.rb - tests for list: [1,2,...n] expressions

require_relative 'test_helper'

class TestVector < BaseSpike
  include CompileHelper
  def test_can_create_empty_list
    result = interpret '[]'
    assert_eq result, []
  end
  def test_list_with_one_value
    result=interpret '[9]'
    assert_eq result, [9]
  end
  def test_list_with_many_elements_can_be_assigned
    result = interpret 'lt=[0,1,2,3,4,5];:lt'
    assert_eq result, [0,1,2,3,4,5]
  end

  # test list index
  def test_list_index_of_simple_list
    result = interpret 'a=[99,98,97];:a[1]'
    assert_eq result, 98
  end
  def test_list_index_can_be_assigned
    result = interpret 'm=[33,4,55];x=:m[1];:x'
    assert_eq result, 4
  end

  # test builtin setting of object within list
  def test_ax_sets_value_in_listmethod
    result = interpret 'a=[5,6,7];ax(:a,2,100);:a'
    assert_eq result, [5,6,100]
  end

  # the way to append an item or many items to a list
  def test_append_1_item_to_list
#    fail 'This list in test should not work'
    result = interpret 'l=[1,22,333,4444];l=:l+[55555];:l'
    assert_eq result, [1,22,333,4444,55555]
  end
  def test_appand_many_lists_into_one
#    fail 'This list in test should not work'
    result = interpret 'l=flatten([[1],[2,3],[4,5,6],[7,8,9,10]]);:l'
    assert_eq result, [1,2,3,4,5,6,7,8,9,10]
  end
  def test_index_can_be_referenced_variable
    result=interpret 'a=[9];y=0;:a[:y]'
    assert_eq result, 9
  end

  # test for able to execute lambdas within list index
  # a=[->() {33}];%a[0]
  def test_can_call_indexed_lambda_from_list
    result = interpret 'z=[->() {44}];%z[0]'
    assert_eq result, 44
  end
  # can deref of list index be a first term in expression?
  def test_can_deref_list_index_be_first_term_in_expression
    result = interpret 'l=[1];:l[0] + 2'
    assert_eq result, 3
  end
  def test_can_execute_lambda_element_in_list_as_first_term_in_expression
    result = interpret 'l=[->() {2}];%l[0] + 2'
  end
  def test_can_have_2_list_indexes_in_expressions
    result = interpret 'l=[ 3 , 5 ];:l[0] + :l[1]'
    assert_eq result, 8
  end

  # test if can index into list with output from fn call
  def test_can_index_list_w_result_of_fn_call
    result = interpret 'a=[1,2]; defn id() { 0 }; :a[id()]'
    assert_eq result, 1
  end
def test_can_call_with_index_w_lambda_call_return
  result = interpret 'a=[1,2]; y=->() {0}; :a[%y]'
  assert_eq result, 1
end

  # test vector element assignment: a=[1,2]; a[0]=9;:a[0] # => 9
  def test_can_assign_element_in_vector
    result = interpret 'a=[0,1];a[0] = 9;:a[0]'
    assert_eq result, 9
  end
  def test_can_index_from_funcall_then_assign_result_subscript
    result = interpret 'a=[1,2,3,4];defn sub() { 1 };a[%sub]=99;:a[1]'
    assert_eq result, 99
  end
  def test_can_assign_to_subscript_computed_from_expression
    result = interpret 'a=[1,2,3];a[44 / 22]=88;:a'
    assert_eq result, [1,2,88]
  end
end
