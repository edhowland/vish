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
  def test_results_of_blocks_can_be_assigned_to_variables
    bc, ctx = compile 'vv={5*3};:vv'
    ci=mkci bc, ctx
    ci.run
    assert_eq @result, '_block_Assign_6'
  end

  # tests for blocks used in conditionals
  def test_block_can_be_called_after_and_with_2_ampersands
    bc, ctx = compile 'twobits=100 / 4; :twobits == 25 && {true; var=false }; :var'
    ci = mkci bc, ctx
    ci.run
    assert_false @result
  end
  def test_conditional_or_with_block_as_second_term_executes_it
    bc, ctx = compile 'false || { var=99; name=100 }; :name == 100'
    ci = mkci bc, ctx
    ci.run
    assert @result
  end
end