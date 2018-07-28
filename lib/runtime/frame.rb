# frame.rb - class Frame,  MainFrame and FunctionFrame
# TODO: Simplify this: Should only be MainFrame and FunctionFrame only

# class Frame - base class for  FunctionFrame 
class Frame
  def initialize
    @ctx = Context.new
    @return_to = []
  end
  attr_accessor :ctx #, :return_to
  def _return_to
    @return_to
  end

  def return_to=(val)
    @return_to << val
  end
  def return_to
    @return_to.last
  end
  def ==(other)
    other.instance_of?(self.class)
  end

  # pop_retto - works to allow multiple frames on stack to coexist with 
  #themselves. Normally, many closures defined in the same environment
  # will set the return_to ivar just, but if one calls another
  # it might quash the prior value of the return_to value.
  # therefore, call this method in the :fret opcode to restore the prior value.
  def pop_retto
    @return_to.pop
  end

  def _clone
    result = self.class.new
    result.ctx = Builtins.clone(@ctx)
    result.return_to = Builtins.clone(@return_to)
    result
  end

  def inspect
    "#{self.class.name}:  ctx: #{@ctx.inspect} return_to: #{@return_to}"
  end
end

# The MainFrame which sits at bottom of CodeInterpreter.frames
class MainFrame < Frame
  def initialize ctx
    super()
    @ctx = ctx
  end
  def frame_id
    "#{self.class.name}_#{self.object_id.to_s}".to_sym
  end
  # get the current binding# Not to be confused with member :binding of the lambda itself
  def _binding
    @ctx.vars
  end
  def _clone
    result = self.class.new Builtins.clone(@ctx)
    result.return_to = Builtins.clone(@return_to)
    result
  end
end

# FunctionFrame - storage for user defined functions
class FunctionFrame < MainFrame
end



# class UnionFrame For type match of either FunctionFrame or MainFrame
# Used in :unwind call emitted by LambdaReturn
class UnionFrame
  def self.===(that)
    that.kind_of?(FunctionFrame) || that.kind_of?(MainFrame)
  end
end
