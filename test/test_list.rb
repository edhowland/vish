# test_list.rb - tests for list: [1,2,...n] expressions

require_relative 'test_helper'

class TestList < BaseSpike
  include CompileHelper
  def test_can_create_empty_list
    result = interpertit '[]'
    assert_eq result, []
  end
end