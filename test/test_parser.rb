# test_parser.rb - tests for VishParser
require_relative 'test_helper'

class TestParser < BaseSpike
  include CompileHelper
  def set_up
    @parser, @transform = parser_transformer
  end
  def test_can_parse_one_space
    @parser.space_plus.parse ' '
  end
  def test_can_parse_2_spaces
    @parser.space_plus.parse '  '
  end
  def test_can_parse_more_than_2_spaces
    @parser.space_plus.parse ' ' * 8
  end
  def test_does_not_parse_less_than_1_space
      assert_raises Parslet::ParseFailed do
      @parser.space_plus.parse ''
    end
  end
end