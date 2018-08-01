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
  def _perform(intp)
    argc = intp.ctx.stack.pop
    argv = intp.ctx.stack.pop
    intp.frames = @frames._clone
    formals = @id[:formals]
    id_parm = formals[0]
    fr = FunctionFrame.new Context.new
    bn = intp.frames.peek.ctx.vars.dup
    bn[id_parm] = argv
    fr.ctx.vars = bn
    # override the normal return in favor of reified frames previous return
    fr.return_to = intp.frames.peek.return_to 
    puts "continuation: return_to #{fr.return_to}"
    intp.frames.push fr

puts "continuation: about to jump to identity func:loc: #{@id[:loc]}  id_parm: #{id_parm}:#{argv}"
    intp.bc.pc = @id[:loc]
  end
  def inspect
    "Continuation: frames.length #{@frames.length}, id function location: #{@id_loc}"
  end
end