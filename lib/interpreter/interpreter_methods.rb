# interpreter_methods.rb - module InterpreterMethods - expose
# CodeInterpreter stuff to runtime.
# E.g. binding()

module InterpreterMethods
  @@interpreter = nil
  def self.add_interpreter interpreter
    @@interpreter = interpreter
  end
  def self.binding()
    @@interpreter.frames.last.ctx.vars
  end
  ## binding?(object) - true if object is some binding
  def self.binding?(object)
    object.instance_of?(BindingType)
  end

  # TODO: These methods need to go into a CompilerMethods module
  ## _attach vector - appends the bytecodes to end of current bytecodes
  def self._attach(vector)
    result = @@interpreter.bc.codes.length
    @@interpreter.bc.codes << vector
    result
  end

  ## _emit(AST) :  Given a AST node subtree, return the emitted bytecodes
  def self._emit(ast)
    Seval.new.eval(ast)
  end
end
