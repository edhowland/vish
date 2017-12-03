#  test_locked_stack.rb - tests for LockedStack

require_relative 'test_helper'

class TestLockedStack < BaseSpike
  def set_up
    @stack = LockedStack.new limit: 10
  end
  def test_can_push_loop_frame
    @stack.push LoopFrame.new
  end
  def test_can_not_pop_below_stack_base
    assert_raises LockedStackLimitReached do
        @stack.pop
    end

  end
  def test_can_push_2_and_pop_1
    @stack.push LoopFrame.new
    @stack.push FunctionFrame
    @stack.pop
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

end