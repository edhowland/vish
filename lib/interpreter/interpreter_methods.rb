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
    Semit.new.emit(ast)
  end
  ## _halt - append a :halt instruction onto emitted bytecodes
  def self._halt(codes)
    codes << :halt
    codes
  end
  ## _jump location - Forces CodeInterpreter to jump to location
  def self._jump(loc)
    @@interpreter.bc.pc = loc
  end
  ## _call(codes) - appends :fret to codes, attaches to executing, builds stack
  # frame and sets return code, and jumps there
  def self._call(codes)
    if codes[-1] == :halt
      codes[-1] =  :fret
    else
      codes << :fret
    end
          frame = FunctionFrame.new(Context.new)
          frame.ctx.vars = @@interpreter.ctx.vars
    frame.return_to = @@interpreter.bc.pc
    loc = _attach(codes)
    @@interpreter.frames.push frame
    @@interpreter.bc.pc = loc
  end

  ## _mklambda - creates a NambdaType object. Can be called with :ncall bytecode
  def self._mklambda(parms, body, loc=nil)
#    puts "in mklambda parms: #{parms}, body: #{body}"
    result = NambdaType.new(parms:parms, body:body, _binding:binding(), loc:loc)
    # compute arity here. Might have to change for variadic lambdas
    result[:arity] = parms.length.zero? ? 0 : parms.length/5
    loc = _attach(result[:body])
    result[:loc] = loc
    result
  end

  ## _codes - output the entire bytecodes. - Used mainly for debugging
  def self._codes()
    @@interpreter.bc.codes
  end
end
