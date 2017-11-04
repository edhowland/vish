# opcodes.rb - Hash of lambdas representing various opcodes
# MUST : Keep has_operand? code up-to-date when adding things here : @ end file

def opcodes
  {
    # Clear the stack. Used at start of every statement.
    cls: ->(bc, ctx) { ctx.clear },
    # :pushc - Pushes value of indexed constant
    pushc: ->(bc, ctx) { i = bc.next; ctx.stack.push ctx.constants[i] },

    # :pushv : Pushes value of named variable
    pushv: ->(bc, ctx) { var = bc.next; ctx.stack.push(ctx.vars[var]) },

    # :pushl - Pushes name of LValue on stack
    pushl: ->(bc, ctx) { var = bc.next; ctx.stack.push(var) },

    # Arithmetic instructions. TODO:  add these: sub: mult: and div:
    # TODO: Should we add Logical ops like :and and :or ?
    # :add - BinararyAdd - pops 2 operands and pushes the result of adding them
    add: ->(bc, ctx) { addend1 = ctx.stack.pop; addend2 = ctx.stack.pop; ctx.stack.push(addend1 + addend2) },

    # :sub - subtracts two things off the stack and pushes the result. The larger one is normally the stack - 1
    sub: ->(bc, ctx) { addend1 = ctx.stack.pop; addend2 = ctx.stack.pop; ctx.stack.push(addend2 - addend1) },

    mult: ->(bc, ctx) { addend1 = ctx.stack.pop; addend2 = ctx.stack.pop; ctx.stack.push(addend2 * addend1) },

    div: ->(bc, ctx) { addend1 = ctx.stack.pop; addend2 = ctx.stack.pop; ctx.stack.push(addend2 / addend1) },

    # comparison operators
    eq: ->(bc, ctx) { v1, v2 = ctx.pop2; ctx.stack.push(v1 == v2) },
    neq: ->(bc, ctx) { v1, v2 = ctx.pop2; ctx.stack.push(v1 != v2) },

    # assignments and dereferences
    # :assign - pop the name of the var, pop the value, store in ctx.vars
    assign: ->(bc, ctx) {  value = ctx.stack.pop; var = ctx.stack.pop; ctx.vars[var] = value },


    # branching instructions
    jmp: ->(bc, ctx) { loc = bc.next; bc.pc = loc },

    # environment instructions : print, . .etc
    print: ->(bc, ctx) { value = ctx.stack.pop; $stdout.puts(value) },
    # machine low-level instructions: nop, halt, jmp, error, etc.
    # :cjmp - jump if top of stack is true. Do we need the opposite?
    nop: ->(bc, ctx) { },
    halt: ->(bc, ctx) { raise HaltState.new },
    error: ->(bc, ctx) { raise ErrorState.new }
  }
end

def has_operand? code
  [:pushc, :pushv, :pushl, :jmp].member? code
end

def has_numeric_operand? code
  [:pushc, :jmp].member? code
end