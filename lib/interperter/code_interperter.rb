# code_interperter.rb - class CodeInterperter - takes ByteCodes, Context and
# runs until bc.codes are exhausted.

class CodeInterperter
  # new: initializes the CodeInterperter object
  # Parameters:
  # bc - ByteCodes object to execute
  # ctx - Context object
  # hook - Proc to run upon interperter initializiaton
  #   is pased bc, ctx
  # Attributes
  # :bc - ByteCodes passed in
  # :ctx - Context
  # :last_exception - The Exception object that was last raised
  # :saved_locations - ??? TODO: fill this in
  # :handlers {} - key value of ByteCodes to run if :int, :_handler_name interrupt happens
  # :register_a - temporary register to hold interrupt values
  def initialize bc, ctx, &hook
    @code_stack = LimitedStack.new(limit: 10)
    @code_stack.push [bc, ctx]
#    @bc = bc
#    @ctx = ctx
    @register_a = Register.new

    @bcodes = opcodes(@register_a)
    hook.call(self.bc, self.ctx, @bcodes) if block_given?
    @saved_locations = []
    @last_exception = nil

    # Setup interrupt handlers
    @handlers = {}
    # The default handler.
    nbc, nctx = default_handler
    @handlers[:_default] = [nbc, nctx]

    # Handle :_exit interrupt
    ebc, ectx = exit_handler
    @handlers[:_exit] = [ebc, ectx]

    # Handle the :_break interrupt
    # Note: We must run this in the current context to unroll the call stack
    bbc = break_handler
    @handlers[:_break] = [bbc, self.ctx]
  end
  attr_accessor :last_exception, :saved_locations, :handlers, :register_a
  def bc
    @code_stack.peek[0]
  end
  def ctx
    @code_stack.peek[1]
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
    instruction.call(self.bc, self.ctx)
  end


  # step: Single steps through the bytecode list.
  def step
          code = fetch
      instruction = decode(code)
      execute(instruction)
  end

  # run: Runs entire self.bc.codes until exhausted. Normally AST will cause this
  # to raise HaltState
  # Parameters:
  # start: starting program counter
  def run start=0
    self.bc.pc = start
    while self.bc.pc <= self.bc.length
      step
    end
    rescue InterruptCalled => ivalue
      bc, ctx = handlers[ivalue.name]
      raise "Unknown exception : #{ivalue.name}. Terminating" if bc.nil?
  # TODO: Should be our own self. Move this rescue clause inside the  above loop???
      handler = self.class.new(bc, ctx)
      handler.run

  # The debugger breakpoint
  rescue BreakPointReached => err
    puts err.message
    puts "at: #{self.bc.pc}"
  @last_exception = err
  rescue HaltState => state
    @last_exception = state
    return state.exit_code
  end

  def restore_breakpt
      self.bc.codes[self.bc.pc] = @saved_locations.pop unless @saved_locations.empty?
  end

  def continue
  restore_breakpt
    run self.bc.pc
  end
  # set_break index - sets a break point at self.bc.codes[index]
  # saves the current opcode at that location in @saved_locations []
  def set_break(index)
    @saved_locations <<  self.bc.codes[index]
    self.bc.codes[index] = :breakpt
  end
  # for debugging
  # peek: What the next call to step will actually run
  def peek
    self.bc.peek
  end
end
