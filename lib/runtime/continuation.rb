# continuation.rb - class Continuation - Holds reified call frame stack

class Continuation < LambdaType
  def initialize frames, _id
    @frames = frames
    @id = _id
  end
  attr_reader :frames, :id
  def perform(intp)
        argc = intp.ctx.stack.pop
        if argc == 1
      argv = intp.ctx.stack.pop
    else
      argv = intp.ctx.stack.pop(argc)
    end
    intp.frames = @frames._clone
    case argc
    when 0
      intp.frames.peek.ctx.stack.push(nil)
    when 1
      intp.frames.peek.ctx.stack.push argv
    else
      intp.frames.peek.ctx.stack.push argv
    end
#    intp.frames.peek.ctx.stack.push argv
    intp.bc.pc = @id[:loc] + (@id[:body].length - 1)
  end

  def inspect
    "Continuation: frames.length #{@frames.length}, id function location: #{@id[:loc]}"
  end
end