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
    argv = intp.ctx.stack.pop(argc)

    bn = binding_dup
    formals.zip(argv).each {|k, v| bn.set(k, v) }
    fr.ctx.vars = bn

#    fr.ctx.stack.push *argv
    handle_variadic(argc, fr, argv)
    intp.frames.push fr
    intp.bc.pc = self[:loc]
    else
    argv = intp.ctx.stack.pop(argc)
      bn = self[:binding].dup
#binding.pry
      formals[0..(argc - 1)].zip(argv).each {|k, v| bn.set(k, v) }
      result = self.class.new(self)
      result[:binding] = bn
      result[:arity] = self[:arity] - argc
      intp.ctx.stack.push(result)
    end
  end
end


