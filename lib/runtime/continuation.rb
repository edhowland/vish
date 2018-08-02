# continuation.rb - class Continuation - Holds reified call frame stack

class Continuation < LambdaType
  def initialize frames, _id
    @frames = frames
    @id = _id
  end
  attr_reader :frames, :id
  def perform(intp)
        argc = intp.ctx.stack.pop
    argv = intp.ctx.stack.pop
    intp.frames = @frames._clone
    intp.frames.peek.ctx.stack.push argv
    intp.bc.pc = @id[:loc] + (@id[:body].length - 1)
  end

  def inspect
    "Continuation: frames.length #{@frames.length}, id function location: #{@id_loc}"
  end
end