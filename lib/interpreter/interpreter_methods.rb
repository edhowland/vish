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
    @@interpreter.bc.codes += vector
    result
  end

  ## _emit(AST) :  Given a AST node subtree, return the emitted bytecodes
  def self._emit(ast)
    Seval.new.eval(ast)
  end

  ## _mklambda - creates a NambdaType object. Can be called with :ncall bytecode
  def self._mklambda(parms, body, loc=nil)
#    puts "in mklambda body: #{body}"
    result = NambdaType.new(parms:parms, body:body, _binding:binding(), loc:loc)
    loc = _attach(result[:body])
    result[:loc] = loc
    result
  end

  ## _codes - output the entire bytecodes. - Used mainly for debugging
  def self._codes()
    @@interpreter.bc.codes
  end
end
