# internal_function.rb - class InternalFunction < ambdaType - wraps Builtins,
# any FFI user supplied functions
# This lambda differs from normal by not actually calling binding.dup

class InternalFunction < LambdaType
  def binding_dup
    self[:binding]
  end
  def perform(intp)
        argc = intp.ctx.stack.pop
        arity = self[:arity]
    raise VishArgumentError.new(arity, argc) if (arity != -1) and   arity != argc
    fr = FunctionFrame.new(Context.new)
    fr.return_to = intp.bc.pc
    fr.ctx.vars = binding_dup

    argv = intp.ctx.stack.pop(argc)
    fr.ctx.stack.push *argv
    fr.ctx.stack.push argc if arity < 0
    intp.frames.push fr
    intp.bc.pc = self[:loc]
  end
  def inspect
    "#{self.class.name} #{self[:name]}"
  end
end