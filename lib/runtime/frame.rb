# frame.rb - class Frame, BlockFrame, LoopFrame, FunctionFrame

# class Frame - base class for BlockFrame, FunctionFrame and LoopFrame
class Frame
  attr_accessor :return_to
  def ==(other)
    other.instance_of?(self.class)
  end
end

class BlockFrame < Frame
end

class FunctionFrame < Frame
end

class LoopFrame < Frame
end
