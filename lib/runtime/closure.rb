# closure.rb - class Closure - stores name of var and frame

# When first created, is a partial closure during code generation.
# After function entry has happened, :storei updates 
# with frames.peek onto the interpreter heap
# Somewhere else, a DerefClosure emits a :pushi, <Closure...? which 
# grabs from the heapand calls its .value method and pushes result on stack.
class Closure
  def initialize name, frame=nil
    @name = name
    @frame = frame
  end

  attr_accessor :name, :frame

  def self.create_id
    id = ('%x' % (Object.new.object_id & 0xffff))
    "Closure_#{id}".to_sym
  end

  def value
    @frame.ctx.vars[@name]
  end
end
