# opcodes.rb - Hash of lambdas representing various opcodes
# MUST : Keep has_operand? code up-to-date when adding things here : @ end file
# opcodes - returns hash of opcodes
# Parameters:
# tmpreg - storage in temporary register
def opcodes tmpreg=nil
  {
    _cls: ' Clear the stack. Used at start of every statement.',
    cls: ->(bc, ctx) { ctx.clear },

    _pushc: 'pushc - Pushes value of indexed constant',
    pushc: ->(bc, ctx) { i = bc.next; ctx.stack.push ctx.constants[i] },

    _pushv: 'pushv : Pushes value of named variable',
    pushv: ->(bc, ctx) { var = bc.next; ctx.stack.push(ctx.vars[var]) },

    _pushl: 'pushl - Pushes name of LValue on stack',
    pushl: ->(bc, ctx) { var = bc.next; ctx.stack.push(var) },
  _pusht: 'Pushes the contents of tmpreg onto the stack.',
  pusht: ->(bc, ctx) { ctx.stack.push(tmpreg.store) },
    _loadt: 'Loads top of stack into tmpreg.',
    loadt: ->(bc, ctx) { tmpreg.load(ctx.stack.pop) },
  _dup: 'Duplicates the top of the stack and pushes the copy back there.',
  dup: ->(bc, ctx) { ctx.stack.push(ctx.stack.peek) },

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
    _jmpf: 'Branch if top of stack is false to position of next operand',
        jmpf: ->(bc, ctx) { ex = ctx.stack.pop; loc = bc.next; bc.pc = loc if ! ex },

    # call stack manipulation :unwind, :pusht
    _unwind: 'Unwinds one object off call stack and pushes on interperter stack.',
    unwind: ->(bc, ctx) { frame = ctx.call_stack.pop; ctx.stack.push frame },
    



  _icall: 'calls the builtin method on the top of the stack',
  icall: ->(bc, ctx) { 
    # get the symbol name of the builtin call
    meth = ctx.stack.pop
    # get the possible arg count
    argc = ctx.stack.pop
    argv = ctx.stack.pop(argc)
    if Builtins.respond_to? meth
      ctx.stack.push(Builtins.send meth, *argv)
    else
      raise "Unknown builtin method #{meth}"
    end
  },

    _str: 'Converts top of stack to a string, pushes the result',
    str: ->(bc, ctx) { ctx.stack.push(ctx.stack.pop.to_s) },

    # environment instructions : print, . .etc
    _print: 'Prints the top 1 item off the stack.',
    print: ->(bc, ctx) { value = ctx.stack.pop; $stdout.puts(value) },

  # flow control : :bcall, :bret, etc
   _bcall: 'pops name of block to jump to. . Pushes return location on call stack for eventual :bret opcode',
   bcall: ->(bc, ctx) { ctx.call_stack.push(bc.pc); var = ctx.stack.pop; loc = ctx.vars[var.to_sym]; bc.pc = loc },
   _bret: 'pops return location off ctx.call_stack. jmps there',
   bret: ->(bc, ctx) { loc = ctx.call_stack.pop; bc.pc = loc },

    # machine low-level instructions: nop, halt, error, etc.


    _nop: 'Null operation.',
    nop: ->(bc, ctx) { },

    _halt: 'Halts the virtual machine.',
    halt: ->(bc, ctx) { raise HaltState.new },

  _int: 'Force an interrupt. Will cause interrupt handler to be called. The operand is the name(:symbol) of the handler to call. Normally :_default.',
  int: ->(bc, ctx) { name = bc.codes[bc.pc]; raise InterruptCalled.new(name) },

  _error: 'Raises an error. ErrorState exception.',
    error: ->(bc, ctx) { raise ErrorState.new bc.next },

  _breakpt: 'Break point. Raises BreakPointReached',
  breakpt: ->(bc, ctx) { raise BreakPointReached.new },
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