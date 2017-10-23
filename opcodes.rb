# opcodes.rb - Hash of lambdas representing various opcodes

def opcodes
  {
    pushc: ->(bc, ctx) { i = bc.next; ctx.stack.push ctx.constants[i] }
  }
end
