# interp.rb - interpret method - interp
# TODO: Make the loop internal guts follow this pseudo-code:
# bcode = fetch
# instruction = decode(bcode)
# execute(instruction)

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
    @bcodes[code]
  end

  def execute instruction
    instruction.call(@bc, @ctx)
  end
end

# main interperter run loop:
def interp(bc, ctx)
  pcodes = opcodes

loop do
  code = bc.next
  break if code.nil?
  raise OpcodeError.new(code) unless pcodes.has_key?(code)
    pcodes[code].call(bc, ctx)
  end

  raise StackNotEmpty.new unless ctx.stack.empty?
end

