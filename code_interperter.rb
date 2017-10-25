# code_interperter.rb - class CodeInterperter - takes ByteCodes, Context and
# runs until bc.codes are exhausted.

class CodeInterperter
  def initialize bc, ctx
    @bc = bc
    @ctx = ctx
    @bcodes = opcodes

  end
  attr_accessor :bc, :ctx

  def fetch
    @bc.next
  end

  def decode(code)
    @bcodes[code] || (raise OpcodeError.new)
  end

  def execute instruction
    instruction.call(@bc, @ctx)
  end
  # run: Runs entire @bc.codes until exhausted. Normally AST will cause this
  # to raise HaltState
  def run
    while @bc.pc <= @bc.length
      code = fetch
      instruction = decode(code)
      execute(instruction)
    end
    raise ErrorState.new('ByteCodes.codes exhausted without encountering HaltState being raised')
  rescue HaltState => state
    raise StackNotEmpty.new unless @ctx.stack.empty?
    return state.exit_code
  end
end
