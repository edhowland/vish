# code_interpreter.rb - class CodeInterpreter - takes ByteCodes, Context and
# runs until bc.codes are exhausted.

class CodeInterpreter
  # new: initializes the CodeInterpreter object
  # Parameters:
  # bc - ByteCodes object to execute
  # ctx - Context object
  #   is pased bc, ctx
  # Attributes
  # :bc - ByteCodes passed in
  # :ctx - Context
  # :last_exception - The Exception object that was last raised
  # :handlers {} - key value of ByteCodes to run if :int, :_handler_name interrupt happens
  # :register_a - temporary register to hold interrupt values
  def initialize bc, ctx 
    @code_stack = LimitedStack.new(limit: 10)
    @code_stack.push [bc, ctx]
    @register_a = Register.new

    @bcodes = opcodes(@register_a)
    @last_exception = nil

    # Setup interrupt handlers
    @handlers = {}
    # The default handler.
    nbc, nctx = default_handler
    @handlers[:_default] = [nbc, nctx]

    # Handle :_exit interrupt
    ebc, ectx = exit_handler
    @handlers[:_exit] = [ebc, ectx]

    # Setup frames. Stack frame for  MainFrame and FunctionFrame
    @frames = LockedStack.new(limit: 1000)
    # The MainFrame, which holds the Context, cannot be popped off this stack
    @frames.push(MainFrame.new(ctx))

    # Storage for the Heap
    @heap = {}

    # hook into dispatcher.
    InterpreterMethods.add_interpreter(self)
    Dispatch << InterpreterMethods unless Dispatch.contains?(InterpreterMethods)
    # Handle the single case for the binding() call lambda proxy
    # It must grab from the penultimate frame, not its own
    ctx.vars[:binding]= InternalFunction.new(parms:[], body:[:frame, :send, :previous, :send, :_binding], _binding:ctx.vars, loc:bc.codes.length)
    ctx.vars[:binding][:name] = :binding
    ctx.vars[:binding][:arity] = -1
    bc.codes += ctx.vars[:binding][:body]


    # setup all FFI methods as :icalls and ctx.vars in scope
    Dispatch.ffi_ruby.each do |ffi|
      ctx.vars[ffi] = InternalFunction.new(parms:[], body:[:pushl, ffi, :icall], _binding:ctx.vars, loc:bc.codes.length)
      ctx.vars[ffi][:name] = ffi
      ctx.vars[ffi][:arity] = -1
      bc.codes += ctx.vars[ffi][:body]
    end
  end
  attr_accessor :last_exception, :handlers, :register_a, :frames, :heap, :code_stack
  def hook hookp
    @hookps ||= []
    @hookps << hookp
  end
  def call_hooks
    @hookps ||= []
    @hookps.each {|h| h.call(self) }
  end

  def bc
    @code_stack.peek[0]
  end

  # ctx - finds the current context. Probably somewhere buried in @frames
  def ctx
    @frames.peek.ctx
  end


  # fetch: gets and returns the next bytecode to run.
  # probably will pass it to decode.
  def fetch
    self.bc.next
  end
  # decode: decodes the passed opcode, and returns the lambda to run in the
  #  execute step. Raises OpcodeError if no opcode exists
  def decode(code)
    @bcodes[code] || (raise OpcodeError.new(code))
  end


  # execute: runs the passed lambda with the parameters self.bc, self.ctx.
  # Parameters:
  # + instruction: The lambda to run
  def execute instruction
    instruction.call(self.bc, self.ctx, self.frames, self)
  end


  # step: Single steps through the bytecode list.
  def step
          code = fetch
      instruction = decode(code)
      result = execute(instruction)
      call_hooks
      result
  end

  def interrupt_entry itype
    bc, ctx = handlers[itype.name] || @handlers[:_default]
    @code_stack.push [bc, ctx]
  end

  def interrupt_exit itype
    @code_stack.pop
  end


  # handle_interrupt. Runs the block until possible interrupt is attempted.
  # Dispatches to either: interrupt_entry or interrupt_exit
  def handle_interrupt &blk
    begin
      yield
    rescue InterruptInterpreter => itype
      self.send itype.action, itype
    end
  end

  # run: Runs entire self.bc.codes until exhausted. Normally AST will cause this
  # to raise HaltState
  # Parameters:
  # start: starting program counter
  def run start=0
    self.bc.pc = start
    while self.bc.pc <= self.bc.length
      handle_interrupt { step }
    end

  rescue TypeError => err
    raise VishTypeError.new(err.message)
  rescue HaltState => state
    @last_exception = state
#    return state.exit_code
    return self.ctx.stack.peek
  end

  # peek: What the next call to step will actually run
  def peek
    self.bc.peek
  end
end
