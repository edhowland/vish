# opcodes.rb - Hash of lambdas representing various opcodes

def opcodes
  {
    # :pushc - Pushes value of indexed constant
    pushc: ->(bc, ctx) { i = bc.next; ctx.stack.push ctx.constants[i] },

    # :pushv : Pushes value of named variable
    pushv: ->(bc, ctx) { var = bc.next; ctx.stack.push(ctx.vars[var]) },
    
    # :pushl - Pushes name of LValue on stack
    pushl: ->(bc, ctx) { var = bc.next; ctx.stack.push(var) },

    # :add - BinararyAdd - pops 2 operands and pushes the result of adding them
    add: ->(bc, ctx) { addend1 = ctx.stack.pop; addend2 = ctx.stack.pop; ctx.stack.push(addend1 + addend2) },

    # assignments and dereferences
    assign: ->(bc, ctx) {  var = ctx.stack.pop; value = ctx.stack.pop; ctx.vars[var] = value },

    # machine low-level instructions: nop, halt, jmp, error, etc.
    nop: ->(bc, ctx) { },
    halt: ->(bc, ctx) { raise HaltState.new },
    error: ->(bc, ctx) { raise ErrorState.new }
  }
end
