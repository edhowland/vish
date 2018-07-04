# curry_function.rb - class CurryFunction < LambdaType - curried function.

class CurryFunction < LambdaType
  def initialize parent
    parent.each do |k, v|
      self[k] = v
    end
  end
  def perform(intp)
    argc = intp.ctx.stack.pop
    if self[:arity] == argc
    fr = FunctionFrame.new(Context.new)
    fr.return_to = intp.bc.pc
    fr.ctx.vars = binding_dup

    argv = intp.ctx.stack.pop(argc)
    fr.ctx.stack.push *argv
    handle_variadic(argc, fr)
    intp.frames.push fr
    intp.bc.pc = self[:loc]
    else
    argv = intp.ctx.stack.pop(argc)
      bn = self[:binding].dup
      

    end
  end
end


