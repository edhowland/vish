# interpreter_methods.rb - module InterpreterMethods - expose
# CodeInterpreter stuff to runtime.
# E.g. binding()

module InterpreterMethods
  @@interpreter = nil
  def self.add_interpreter interpreter
    @@interpreter = interpreter
  end
  ## get the current binding
  # Remember, if called through lambda proxy, gets that binding, not current  fn

  ## _attach vector - appends the bytecodes to end of current bytecodes
  def self._attach(vector)
    result = @@interpreter.bc.codes.length
    @@interpreter.bc.codes += vector
    result
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
  ## _call(codes) - appends :jmp, current.pc to codes, attaches to executing codes in interpreter.
  def self._call(codes)
    if codes[-1] == :halt
      codes[-1] =  :jmp
      codes << @@interpreter.bc.pc
    else
      codes += [:jmp, @@interpreter.bc.pc]
    end
    loc = _attach(codes)
    @@interpreter.bc.pc = loc
  end

  ## _mklambda - creates a LambdaType object. Can be called with :ncall bytecode

  def self._mklambda(parms, body, id, loc=nil)
    result = LambdaType.new(parms:parms, body:body, _binding:@@interpreter.ctx.vars(), loc:loc)
    # compute arity here. Might have to change for variadic lambdas
    result[:arity] = parms.length   #parms.length.zero? ? 0 : parms.length/5
    g = self._globals
    if g.exist? id
      loc = g[id]
    else
      loc = _attach(result[:body])
    g[id] = loc
    end
    result[:loc] = loc
    result[:id] = id
    result
  end
  ## _globals - returns top level bindings
  def self._globals()
    @@interpreter.frames[0].ctx.vars
  end
  ## _toprun(codes) - run these codes at the top level
  def self._toprun(codes)
    ctx = Context.new
    ctx.vars = _globals()
    fr = FunctionFrame.new(ctx)
    @@interpreter.frames.push fr
    _call(codes)
    @@interpreter.frames.pop
  end

  ## _codes - output the entire bytecodes. - Used mainly for debugging
  def self._codes()
    @@interpreter.bc.codes
  end
  def self._mkcontinuation(frames, id_function)
    Continuation.new(frames._clone, id_function)
  end

end
