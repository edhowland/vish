# test_frame - tests for Frame and its children

require_relative 'test_helper'

class TestFrame < BaseSpike
  def set_up
    @ctx = Context.new
  end

  def test_function_frame_is_equal_to_its_self
    assert FunctionFrame.new(@ctx) == FunctionFrame.new(@ctx)
  end

end

