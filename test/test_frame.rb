# test_frame - tests for Frame and its children

require_relative 'test_helper'

class TestFrame < BaseSpike
  def test_block_frame_is_not_equal_function_frame
    assert BlockFrame.new != FunctionFrame.new
  end
  def test_block_frame_does_not_equal_loopframe
    assert BlockFrame.new != LoopFrame.new
  end
  def test_function_frame_is_not_equal_block_frame
    assert FunctionFrame.new != BlockFrame.new
  end
  def test_block_frame_matches_itself
    assert BlockFrame.new == BlockFrame.new
  end
  def test_function_frame_is_equal_to_its_self
    assert FunctionFrame.new == FunctionFrame.new
  end
  def test_loop_frame_does_not_equal_function_frame
    assert LoopFrame.new != FunctionFrame.new
  end
  def test_loop_frame_is_not_equal_block_frame
    assert LoopFrame.new != BlockFrame.new
  end
  def test_function_frame_is_not_equal_loop_frame
    assert FunctionFrame.new != LoopFrame.new
  end
  def test_loop_frame_is_equal_itself
    assert LoopFrame.new == LoopFrame.new
  end
end
