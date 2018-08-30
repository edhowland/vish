#  test_locked_stack.rb - tests for LockedStack

require_relative 'test_helper'

class TestLockedStack < BaseSpike
  include CompileHelper
  def set_up
    @stack = LockedStack.new limit: 10
  end
  def test_can_not_pop_below_stack_base
    assert_raises LockedStackLimitReached do
        @stack.pop
    end

  end
  # test push many things
  def test_can_push_more_than_thing
    @stack.push 0
    a = [1,2,3]
    @stack.push(*a)
    assert_eq @stack, [0, 1, 2, 3]
  end
  def test_can_still_pop_0_items_off_stack_and_get_empty_array
  @stack = LimitedStack.new limit: 10
    result = @stack.pop(0)
    assert_is result, Array
    assert result.empty?
  end
  def test_safe_pop_does_not_raise_underflow_error_only_returns_nil
    @stack = LimitedStack.new limit: 10
    assert @stack.safe_pop.nil?
  end

  # tests for swap
  def test_swap_swaps_top_2_elements
    @stack.push 1,2
    @stack.swap
    assert_eq @stack, [2, 1]
  end

  # test for underflow conditions
  def test_underflow_w_no_pop_args
    stack = LimitedStack.new limit:10
    assert_raises StackUnderflow do
      stack.pop
    end
  end
  def test_no_stack_underflow_w_pop_0
    stack = LimitedStack.new limit:10
    stack.pop(0)
  end
  def test_stack_underflow_w_pop_greater_0
    stack = LimitedStack.new limit:10
    assert_raises StackUnderflow do
      stack.pop(1)
    end
  end
  def test_no_stack_underflow_w_one_item_on_stack_and_pop_1
    stack = LimitedStack.new limit: 10
    stack.push 1
    stack.pop(1)
  end

  # test for LimitedStack.safe_pop
  def test_limited_stack_can_safe_pop_1_existing_element
    stack = LimitedStack.new limit:10
    stack.push 9
    assert_eq stack.safe_pop, 9
  end
  def test_limited_stack_safe_pop_w_empty_is_nil_and_does_not_raise_stack_underflow
    stack = LimitedStack.new limit:10
    assert stack.safe_pop.nil?
  end
  # previous frame
  def test_previous_frame_is_main_frame
    @stack.push MainFrame.new Context.new
    @stack.push FunctionFrame.new Context.new
    assert_is @stack.previous, MainFrame
  end
  def test_previous_raises_error_if_not_frames_on_stack
    assert_raises VishRuntimeError do
      @stack.previous
    end
    def test_previous_raises_runtime_error_if_only_1_item_on_stack
      @stack.push MainFrame.new Context.new
      assert_raises VishRuntimeError do
        @stack.previous
      end
    end
  end

  # test clone of limited stack
  def _test_clone_preserves_length
    x=interpret 'defn foo() {clone(:_intp)};%foo'
    assert_eq x.frames.length, 2
  end
  def test_clone_of_limited_stack_starts_at_0_remains_0
    ls = LimitedStack.new limit:100
    x = ls.clone
    assert_eq x.length, 0
  end
  def test_limited_stack_of_1_after_clone_is_still_1
    ls = LimitedStack.new limit:100
    ls.push 3
    x = ls.clone
    assert_eq x.length, 1

  end
  def test_underbar_clone_does_deep_copy
    ls = LimitedStack.new limit: 100
    ls.push Object.new
    x = ls._clone
    assert_neq x[0], ls[0]
  end
end
