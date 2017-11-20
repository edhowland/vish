# opcodes.rb - Hash of lambdas representing various opcodes
# MUST : Keep has_operand? code up-to-date when adding things here : @ end file

def opcodes
  {
    _cls: ' Clear the stack. Used at start of every statement.',
    cls: ->(bc, ctx) { ctx.clear },

    _pushc: 'pushc - Pushes value of indexed constant',
    pushc: ->(bc, ctx) { i = bc.next; ctx.stack.push ctx.constants[i] },

    _pushv: 'pushv : Pushes value of named variable',
    pushv: ->(bc, ctx) { var = bc.next; ctx.stack.push(ctx.vars[var]) },

    _pushl: 'pushl - Pushes name of LValue on stack',
    pushl: ->(bc, ctx) { var = bc.next; ctx.stack.push(var) },

    # Arithmetic instructions.
    _add:  'Add - BinararyAdd - pops 2 operands and pushes the result of adding them',
    add: ->(bc, ctx) { l,r = ctx.stack.pop(2); ctx.stack.push(l + r) },

    _sub: 'Sub - subtracts two things off the stack and pushes the result. The larger one is normally the stack - 1',
    sub: ->(bc, ctx) { addend1 = ctx.stack.pop; addend2 = ctx.stack.pop; ctx.stack.push(addend2 - addend1) },

    _mult: 'Multiplies top 2 items off stack, pushes result.',
    mult: ->(bc, ctx) { addend1 = ctx.stack.pop; addend2 = ctx.stack.pop; ctx.stack.push(addend2 * addend1) },

    _div: 'Divides the top 2 items off stack, pushes the result.',
    div: ->(bc, ctx) { addend1 = ctx.stack.pop; addend2 = ctx.stack.pop; ctx.stack.push(addend2 / addend1) },

    _mod: 'Modulo, computes the modulo of the top 2 arguments on the stack and pushes the result',
    mod: ->(bc, ctx) { l, r = ctx.stack.pop(2); ctx.stack.push(l % r) },

    _exp: 'performs exponenation on top 2 items on stack, pushes the rsult',
    exp: ->(bc, ctx) { l, r = ctx.stack.pop(2); ctx.stack.push(l ** r) },

    # logical operators
    _and: 'Ands the top 2 items off the stack, pushes the result: true, false.',
    and: ->(bc,ctx) { v1, v2 = ctx.pop2; ctx.stack.push(v1 && v2) },

    _or: 'Ors the top 2 items off the stack, pushes the result: true or false.',
    or: ->(bc,ctx) { v1, v2 = ctx.pop2; ctx.stack.push(v1 || v2) },

    _not: 'Negates the top 1 item off the stack, pushes the result: true or false.',
    not: ->(bc, ctx) { ctx.stack.push(! ctx.stack.pop) },

    # comparison operators
    _eq: 'Compares the top 2 items off the stack for equality, pushes the result: true or false.',
    eq: ->(bc, ctx) { v1, v2 = ctx.pop2; ctx.stack.push(v1 == v2) },

    _neq: 'Negates the meaning of equality of the top 2 items on the stack. Pushes true if  if they are inequal.',
    neq: ->(bc, ctx) { v1, v2 = ctx.pop2; ctx.stack.push(v1 != v2) },

    # assignments and dereferences
    _assign: 'assign - pop the name of the var, pop the value, store in ctx.vars.',
    assign: ->(bc, ctx) {  value = ctx.stack.pop; var = ctx.stack.pop; ctx.vars[var] = value },


    # branching instructions
    _jmp: 'Jump to the value of the operand in the bytecode list.',
    jmp: ->(bc, ctx) { loc = bc.next; bc.pc = loc },

    _jmpt: 'branch if top of stack is true to the location contained in the operand of the bytecode list.',
    jmpt: ->(bc, ctx) { ex = ctx.stack.pop; loc = bc.next; bc.pc = loc if ex },

  _icall: 'calls the builtin method on the top of the stack',
  icall: ->(bc, ctx) { 
    meth = ctx.stack.pop
    if Builtins.respond_to? meth
      ctx.stack.push(Builtins.send meth)
    else
      raise "Unknown builtin method #{meth}"
    end
  },

    _str: 'Converts top of stack to a string, pushes the result',
    str: ->(bc, ctx) { ctx.stack.push(ctx.stack.pop.to_s) },

    # environment instructions : print, . .etc
    _print: 'Prints the top 1 item off the stack.',
    print: ->(bc, ctx) { value = ctx.stack.pop; $stdout.puts(value) },

    # machine low-level instructions: nop, halt, jmp, error, etc.
    _nop: 'Null operation.',
    nop: ->(bc, ctx) { },

    _halt: 'Halts the virtual machine.',
    halt: ->(bc, ctx) { raise HaltState.new },

  _errror: 'Raises an error. ErrorState exception.',
    error: ->(bc, ctx) { raise ErrorState.new },

    _spy: 'Spies on the state of bytecodes, context.',
    spy: ->(bc, ctx) { puts 'bc:', bc.inspect; puts 'ctx:', ctx.inspect }
  }
end

def has_operand? code
  [:pushc, :pushv, :pushl, :jmp, :jmpt].member? code
end

def has_numeric_operand? code
  [:pushc, :jmp, :jmpt].member? code
end