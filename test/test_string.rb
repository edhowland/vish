# test_string.rb - tests for string literals, AST nodes, etc.

require_relative 'test_helper'

class TestString < BaseSpike
  include CompileHelper

  def set_up
    @parser, @transform = parser_transformer
  end

  def test_can_parse_double_cuoted_string
    @parser.parse '"this is a string"'
  end
  def test_unterminated_string_raises_parslet_parse_failed
    assert_raises Parslet::ParseFailed do
    @parser.parse' "This'
    end
  end



  # compile steps
  def test_compile_empty_string
    assert_empty interpret('n1=""; :n1')
  end
  def test_handle_escape_sequence
    string = '"' + 'line' + [92,'n',92,92].map(&:chr).join + '"'
    result = interpret string
    assert_eq result, "line\n\\"
  end
  def test_string_interprets_internal_expression_with_addition
    result = interpret '"when you add 4+4 you get %{4+4}"'
    assert_eq result, 'when you add 4+4 you get 8'
  end
  def test_really_complex_string_w_strings_escape_sequences_and_interpolations
    result = interpret '"a1: %{5-3*6}\na2: %{12 == 3 * 4}\n"'
    assert_eq result, "a1: -13\na2: true\n"
  end

  # Single quoted strings
  def test_single_quote_string
    result = interpret "'hello'"
    assert_eq result, 'hello'
  end
  def test_single_quoted_string_can_have_backslash
    result = interpret "'---\\---'"
    assert_eq result, '---\\---'
  end

  # can concatenate strings
  def test_can_concat_sq_strings
    result = interpret "'x' + 'x'"
    assert_eq result, 'xx'
  end
  def test_can_concat_dq_strings
    result = interpret '"y" + "y"'
    assert_eq result, 'yy'
  end
  def test_can_concat_sq_w_dq_string
    result = interpret '"x" + \'y\''
    assert_eq result, 'xy'
  end
  def test_can_concat_sq_and_dq_strings
    result = interpret '\'x\' + "y"'
    assert_eq result, 'xy'
  end

  # Bug: somehow introduced this empty string buf
  def test_bug_empty_single_quore_string
    assert_eq interpret("s=''"), ''
  end
  def test_empty_double_quoted_string
    assert_eq interpret('""'), ""
  end
end