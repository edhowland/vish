# frame.rb - class Frame, BlockFrame, LoopFrame, FunctionFrame

# class Frame - base class for BlockFrame, FunctionFrame and LoopFrame
class Frame
  def initialize
    @ctx = Context.new
    @return_to = nil
  end
  attr_accessor :ctx, :return_to
  def ==(other)
    other.instance_of?(self.class)
  end
end

class BlockFrame < Frame
end

# The MainFrame which sits at bottom of CodeInterpreter.frames
class MainFrame < Frame
  def initialize ctx
    @ctx = ctx
  end
end

# FunctionFrame - storage for user defined functions
class FunctionFrame < MainFrame
end

class LoopFrame < Frame
end
