# test_api.rb - tests for  lib/api/*

require_relative 'test_helper'

class TestApi < BaseSpike
  # array_join
  def test_array_join_with_empty
    assert_empty array_join([], :+)
  end
  def test_array_join_w_1_element_returns_itself
    a = [1]
    result = array_join(a, :+)
    assert_eq result, a
  end
  def test_array_join_w_2_elements_joins_with_sep
    result = array_join([0,1], :+)
    assert_eq result, [0, :+, 1]
  end
  def test_array_join_w_odd_length_properly_works
    a = [0,1,2,3,4]
    result = array_join(a, :+)
    assert_eq result, [0, :+, 1, :+, 2, :+, 3, :+, 4]
  end
  def test_array_join_works_w_different_separator
    a= [:b, :c, :d]
    result = array_join a, '0'
    assert_eq result, [:b, '0', :c, '0', :d]
  end


  # array_split
  def test_array_split_2_different_objects_are_split
    assert_eq array_split([1, 'a']) { |e| ! e.instance_of? String }, [[1], ['a']]
  end
  def test_array_split_w_one_string_and_non_string_is_2_elements
    assert_eq array_split(['a', 1]) { |e| ! e.instance_of? String }, [['a'], [1]]
  end
  def test_array_split_empty_input_is_
    assert_eq array_split([]) {|e| true }, []
  end
  def test_array_split_w_continous_runs_of_non_block_true_accumulates
    assert_eq array_split(['c', 'a', 't', 1, 2, 'd', 'o', 'g']) {|e| ! e.instance_of? String }, [['c', 'a', 't'], [1], [2], ['d', 'o', 'g']]
  end
  def test_array_split_w_starting_non_matching_still_works
    assert_eq array_split([99, 'c', 'a', 't', 1, 2, 'd', 'o', 'g']) {|e| ! e.instance_of? String }, [[99], ['c', 'a', 't'], [1], [2], ['d', 'o', 'g']]
  end
  def test_array_split_w_only_matching_is_length_1
    assert_eq array_split(['h', 'e', 'l', 'l', 'o']) {|e| ! e.instance_of? String }, [['h', 'e', 'l','l', 'o']]
  end
  def test_array_split_w_only_integers_are_the_same_length_as_original_input_array
    assert_eq array_split([1,2,3]) {|e| ! e.instance_of? String }, [[1], [2], [3]]
  end
  # rl_compress
  def test_rl_compress_w_empty_returns_empty
    assert_eq rl_compress([]), []
  end
  def test_rl_compress_returns_single_char_w_given_single_string
    assert_eq rl_compress(['a']), ['a']
  end
  def test_rl_compress_returns_unchanged_non_string_things
    assert_eq rl_compress([1,2]), [1,2]
  end
  def test_rl_compress_compacts_strings
    assert_eq rl_compress(['a', 'b']), ['ab']
  end
  def test_rl_compress_compacts_string_and_leaves_other_things_unchanges
    assert_eq rl_compress([1, 'a', 'b', 2]), [1, 'ab', 2]
  end
end