# test_frame - tests for Frame and its children

require_relative 'test_helper'

class TestFrame < BaseSpike
  def set_up
    @ctx = Context.new
  end

  def test_function_frame_is_equal_to_its_self
    assert FunctionFrame.new(@ctx) == FunctionFrame.new(@ctx)
  end
  def test_loop_frame_does_not_equal_function_frame
    assert LoopFrame.new != FunctionFrame.new(@ctx)
  end

  def test_function_frame_is_not_equal_loop_frame
    assert FunctionFrame.new(@ctx) != LoopFrame.new
  end
  def test_loop_frame_is_equal_itself
    assert LoopFrame.new == LoopFrame.new
  end
end

