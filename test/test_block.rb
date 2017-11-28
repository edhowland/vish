# buffer test_block.rb - tests for blocks ... e.g.  { echo hello }


require_relative 'test_helper'

class TestBlock < BaseSpike
  include CompileHelper
  def set_up
    @parser, @transform = parser_transformer
  end

  def test_simple_block
    assert_eq interpertit('{1}'), 1
  end
  def test_block_can_be_1_statement_of_many
    assert_eq interpertit( '{var=1+2};:var'), 3
  end
  def test_results_of_blocks_can_be_assigned_to_variables
    assert_eq interpertit( 'vv={5*3};:vv'),'_block_Assign_6'
  end

  # tests for blocks used in conditionals
  def test_block_can_be_called_after_and_with_2_ampersands
    assert_false interpertit( 'twobits=100 / 4; :twobits == 25 && {true; var=false }; :var')
  end
  def test_conditional_or_with_block_as_second_term_executes_it
    assert interpertit( 'false || { var=99; name=100 }; :name == 100')
  end

  # saving blocks in variables
  def test_can_save_block_and_ten_retrieve_and_execute_it_later
    assert_eq interpertit( 'var1={5+3}; 4*3; %var1'), 8
  end
  def test_saved_block_can_run_in_new_context
    result = interpertit <<-EOC
val=5
bk={ :val + 6 }
val=10
%bk
EOC
    assert_eq result, 16
  end
  def test_result_of_calling_block_can_be_assigned
    assert_eq interpertit( 'bk={1+3}; jj=%bk; :jj'), 4
  end
  def test_block_can_call_another_block
    assert_eq interpertit( 'bk1={1+3};bk2={5*%bk1};%bk2'), 20
  end
  def test_recursion_reaches_stack_limit
    bc, ctx = compile 'bk={ %bk }; %bk'
    ci = mkci bc, ctx
    assert_raises StackLimitReached do
      ci.run
    end
  end

  # check if can immediately execute a block and assign it
  def test_can_assign_variable_to_result_of_running_block_inplace
      assert_eq interpertit( 'yy=%{22 * 10}; :yy'), 220
  end

  # test that or skips over right block
  def test_binary_or_skips_over_right_block
    assert_eq interpertit('name=1; true || { var=1; name=2}; :var'), Undefined
#    assert_eq ctx.vars[:name], 1
  end

  # test return statements
  def test_return_true_actually_returns_true
    assert interpertit('bk={ return true }; %bk')
  end
  def test_returns_returns_complex_expression
    assert_eq interpertit('bk1={ return 5*5 }; %bk1'), 25
  end
end