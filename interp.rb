# interp.rb - interpret method - interp

# main interperter run loop:
def interp(bc, ctx)
pcodes = opcodes

loop do
  code = bc.next
  break if code.nil?
  pcodes[code].call(bc, ctx)
end
end

