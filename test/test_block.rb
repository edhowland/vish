# buffer test_block.rb - tests for blocks ... e.g.  { echo hello }


require_relative 'test_helper'

class TestBlock < BaseSpike
  include CompileHelper
  def set_up
    @parser, @transform = parser_transformer
  end

  def test_simple_block
    assert_eq interpret('{1}'), 1
  end
  def test_block_can_be_1_statement_of_many
    assert_eq interpret( '{var=1+2};:var'), 3
  end
  def test_results_of_blocks_can_be_assigned_to_variables
    result = interpret('vv=:{5*3};:vv')
    assert_is result, LambdaType
  end

  # tests for blocks used in conditionals
  def test_block_can_be_called_after_and_with_2_ampersands
    assert_false interpret( 'twobits=100 / 4; :twobits == 25 && {true; var=false }; :var')
  end
  def test_conditional_or_with_block_as_second_term_executes_it
    assert interpret( 'false || { var=99; name=100 }; :name == 100')
  end

  # saving blocks in variables
  def test_can_save_block_and_ten_retrieve_and_execute_it_later
    assert_eq interpret( 'var1=:{5+3}; 4*3; %var1'), 8
  end
  def test_saved_block_can_run_in_new_context
    result = interpret <<-EOC
val=5
bk=:{ :val + 6 }
val=10
%bk
EOC
    assert_eq result, 16
  end
  def test_result_of_calling_block_can_be_assigned
    assert_eq interpret( 'bk=:{1+3}; jj=%bk; :jj'), 4
  end
  def test_block_can_call_another_block
    assert_eq interpret( 'bk1=:{1+3};bk2=:{5*%bk1};%bk2'), 20
  end
  # commented out because of memory overflow when running test/all_tests.rb
#  def test_recursion_reaches_stack_limit
#    bc, ctx = compile 'bk=:{ %bk }; %bk'
#    ci = mkci bc, ctx
#    # skip this test if tail call optimization is on. Will inifinite loop
#    # because no call stack frames are created
#    if !ENV['TCO']
#      assert_raises StackLimitReached do
#        ci.run
#      end
#    end
#  end

  # check if can immediately execute a block and assign it
  def test_can_assign_variable_to_result_of_running_block_inplace
      assert_eq interpret( 'yy=%{22 * 10}; :yy'), 220
  end

  # test that or skips over right block
  def test_binary_or_skips_over_right_block
    assert_eq interpret('name=1; true || { var=1; name=2}; :var'), Undefined
#    assert_eq ctx.vars[:name], 1
  end

  # test return statements
  def test_return_true_actually_returns_true
    assert interpret('bk=:{ return true }; %bk')
  end
  def test_returns_returns_complex_expression
    assert_eq interpret('bk1=:{ return 5*5 }; %bk1'), 25
  end
# nested blocks
def test_nested_blocks
  assert interpret('{ { true } }')
end

  # loop under block stuff
  def test_loops_can_occur_inside_blocks
    bc, ctx = compile '{ loop { break } }'
  end

  # exiting from deeply nested blocks
  def test_can_exit_from_deeply_nested_blocks
    bc, ctx = compile '{{{exit}}}'
    ci = mkci bc, ctx
    ci.run
  end

  # found bugs:
  def _test_can_pass_blocks_to_functions
    result=interpret <<EOD
# bk.vs - test out block
x=10
bk=:{:x / 2}
defn foo(x,b) { %b }
foo(100,:bk)
EOD
assert_eq result, 5
  end

  # passing blocks to functions
  def test_can_pass_block_to_function
    result = interpret 'defn foo(bk) { %bk };foo(:{1})'
    assert_eq result, 1
  end
  def test_can_pass_mix_of_blocks_lambdas_and_ints_to_funcall
    result = interpret 'defn bar(l1,n2,b3,n4,b5) { %l1 + :n2 + %b3 + :n4 + %b5 };bar(->() {1},2,:{3},4,:{5})'
    assert_eq result, 15
  end
  def test_blocks_become_closures_when_passed_as_parameters
    result = interpret 'defn baz(b) { %b + 1 };cl=9;baz(:{:cl})'
    assert_eq result, 10
  end
  def test_blocks_become_closures_when_assigned_to_a_variable
    result = interpret 'xl=4;bk=:{:xl + 10};%bk'
    assert_eq result, 14
  end

  # test for passing blocks to lambdas
  def test_can_pass_blocks_to_lambdas
    result = interpret 'm=->(b) { %b };%m(:{1})'
    assert_eq result, 1
  end
  # Can return blocks from functions
  def test_can_return_block_from_function
    result = interpret('defn foo(a) {:{:a - 1}};v=foo(3);%v')
    assert_eq result, 2
  end
end
