# frame.rb - class Frame, BlockFrame, LoopFrame, FunctionFrame

class Frame
  attr_accessor :return_to
end

class BlockFrame < Frame
end