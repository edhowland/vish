# interp.rb - interpret method - interp
# TODO: Make the loop internal guts follow this pseudo-code:
# bcode = fetch
# instruction = decode(bcode)
# execute(instruction)
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

