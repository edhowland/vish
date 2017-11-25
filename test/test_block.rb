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

  # saving blocks in variables
  def test_can_save_block_and_ten_retrieve_and_execute_it_later
    bc, ctx = compile 'var1={5+3}; 4*3; %var1'
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 8
  end
  def test_saved_block_can_run_in_new_context
    bc, ctx = compile <<-EOC
val=5
bk={ :val + 6 }
val=10
%bk
EOC
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 16
  end
  def test_result_of_calling_block_can_be_assigned
    bc, ctx = compile 'bk={1+3}; jj=%bk; :jj'
    ci = mkci bc, ctx
    ci.run
    assert_eq @result, 4
  end
  def test_block_can_call_another_block
    bc, ctx = compile 'bk1={1+3};bk2={5*%bk1};%bk2'
    ci=mkci bc, ctx
    ci.run
    assert_eq @result, 20
  end
end