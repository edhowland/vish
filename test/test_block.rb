# buffer test_block.rb - tests for blocks ... e.g.  { echo hello }


require_relative 'test_helper'

class TestBlock < BaseSpike
  include CompileHelper
  def set_up
    @parser, @transform = parser_transformer
  end

  def test_simple_block
    bc, ctx = compile '{1}'
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 1
  end
  def test_block_can_be_1_statement_of_many
    bc, ctx = compile '{var=1+2};:var'
    ci= mkci bc, ctx
    ci.run
    assert_eq @result,  3
  end
end