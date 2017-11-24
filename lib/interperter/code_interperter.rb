# code_interperter.rb - class CodeInterperter - takes ByteCodes, Context and
# runs until bc.codes are exhausted.

class CodeInterperter
  def initialize bc, ctx, &hook
    @bc = bc
    @ctx = ctx
    @bcodes = opcodes
    hook.call(@bc, @ctx, @bcodes) if block_given?
    @saved_locations = []
    @last_exception = nil
  end
  attr_accessor :bc, :ctx, :last_exception, :saved_locations


  # fetch: gets and returns the next bytecode to run.
  # probably will pass it to decode.
  def fetch
    @bc.next
  end
  # decode: decodes the passed opcode, and returns the lambda to run in the
  #  execute step. Raises OpcodeError if no opcode exists
  def decode(code)
    @bcodes[code] || (raise OpcodeError.new(code))
  end


  # execute: runs the passed lambda with the parameters @bc, @ctx.
  # Parameters:
  # + instruction: The lambda to run
  def execute instruction
    instruction.call(@bc, @ctx)
  end


  # step: Single steps through the bytecode list.
  def step
          code = fetch
      instruction = decode(code)
      execute(instruction)
  end

  # run: Runs entire @bc.codes until exhausted. Normally AST will cause this
  # to raise HaltState
  # Parameters:
  # start: starting program counter
  # finalize : block  to be run at end of run
  # If this execption(HaltState) is raised, then finalize block is run
  # Normally, this is a NOP
  def run start=0, finalize: ->(bc, ctx) { }
    @bc.pc = start
    while @bc.pc <= @bc.length
      step
    end
  rescue BreakPointReached => err
    puts err.message
    puts "at: #{@bc.pc}"
  @last_exception = err
  rescue HaltState => state
    finalize.call(@bc, @ctx)
    @last_exception = state
    return state.exit_code
  end

  def restore_breakpt
      @bc.codes[@bc.pc] = @saved_locations.pop unless @saved_locations.empty?
  end

  def continue
  restore_breakpt
    run @bc.pc
  end
  # set_break index - sets a break point at @bc.codes[index]
  # saves the current opcode at that location in @saved_locations []
  def set_break(index)
    @saved_locations <<  @bc.codes[index]
    @bc.codes[index] = :breakpt
  end
  # for debugging
  # peek: What the next call to step will actually run
  def peek
    @bc.peek
  end
end
