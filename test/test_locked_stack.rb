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
end