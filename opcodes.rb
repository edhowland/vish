# opcodes.rb - Hash of lambdas representing various opcodes

def opcodes
  {
    pushc: ->(bc, ctx) { i = bc.next; ctx.stack.push ctx.constants[i] },
    add: ->(bc, ctx) { addend1 = ctx.stack.pop; addend2 = ctx.stack.pop; ctx.stack.push(addend1 + addend2) }
  }
end
