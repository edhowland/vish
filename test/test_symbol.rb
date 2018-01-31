# test_symbol.rb - tests for SymbolType

require_relative 'test_helper'

class TestSymbol < BaseSpike
  include CompileHelper
  def test_can_be_a_symbol
    result = interpret 'mysym:'
    assert_is result, Symbol
  end
end