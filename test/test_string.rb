# test_string.rb - tests for string literals, AST nodes, etc.

require_relative 'test_helper'

class TestString < BaseSpike
  include CompileHelper

  def set_up
    @parser, @transform = parser_transformer
    @result = ''
  end

  def test_can_parse_double_cuoted_string
    @parser.parse '"this is a string"'
  end
  def test_unterminated_string_raises_parslet_parse_failed
    assert_raises Parslet::ParseFailed do
    @parser.parse' "This'
    end

  end


  def test_string_literal_object
    string = 'this is a string'
    lit  = StringLiteral.new string
    assert_eq lit.value, string
  end

  # compile steps
  def test_compile_empty_string
    interpertit 'n1=""; :n1'
    assert_empty @result
  end
  def test_handle_escape_sequence
    string = '"' + 'line' + [92,'n',92,92].map(&:chr).join + '"'
    interpertit string
    assert_eq @result, "line\n\\"
  end
end