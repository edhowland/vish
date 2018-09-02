# internal_function.rb - class InternalFunction < ambdaType - wraps Builtins,
# any FFI user supplied functions
# This lambda differs from normal by not actually calling binding.dup

class InternalFunction < LambdaType
  def binding_dup
    self[:binding]
  end
  # check arity
  def check_arity(argc)
    arity= self[:arity]
    raise VishArgumentError.new(arity, argc) if (arity != -1) and   arity != argc
  end
  def handle_variadic(argc, fr, argv=[])
    arity= self[:arity]
    if arity < 0
      fr.ctx.stack.push(*argv)
      fr.ctx.stack.push argc
        end
  end

  # bypass tail call optimizations for internal functions
  def tail_call(intp)
    apply(intp)
  end

  def inspect
    "#{self.class.name} #{self[:name]}"
  end
end