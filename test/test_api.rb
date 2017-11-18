# test_api.rb - tests for  lib/api/*

require_relative 'test_helper'


class TestApi < BaseSpike
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
end