# opcodes.rb - Hash of lambdas representing various opcodes
# MUST : Keep has_operand? code up-to-date when adding things here : @ end file
# opcodes - returns hash of opcodes
# Parameters:
# tmpreg - storage in temporary register
def opcodes tmpreg=nil
  {
    _cls: ' Clear the stack. Used at start of every statement.',
    cls: ->(bc, ctx, _) { ctx.clear },

    _pushc: 'pushc - Pushes value of indexed constant',
    pushc: ->(bc, ctx, _) { i = bc.next; ctx.stack.push ctx.constants[i] },

    _pushv: 'pushv : Pushes value of named variable',
    pushv: ->(bc, ctx, _) { var = bc.next; ctx.stack.push(ctx.vars[var]) },

    _pushl: 'pushl - Pushes literal of LValue on stack',
    pushl: ->(bc, ctx, _) { var = bc.next; ctx.stack.push(var) },
  _pusht: 'Pushes the contents of tmpreg onto the stack.',
  pusht: ->(bc, ctx, _) { ctx.stack.push(tmpreg.store) },
    _loadt: 'Loads top of stack into tmpreg.',
    loadt: ->(bc, ctx, _) { tmpreg.load(ctx.stack.pop) },
  _dup: 'Duplicates the top of the stack and pushes the copy back there.',
  dup: ->(bc, ctx, _) { ctx.stack.push(ctx.stack.peek) },
  _swp: 'Swaps top 2 items on stack',
  swp: ->(bc, ctx, fr) { ctx.stack.swap },

    # Arithmetic instructions.
    _add:  'Add - BinararyAdd - pops 2 operands and pushes the result of adding them',
    add: ->(bc, ctx, _) { l,r = ctx.stack.pop(2); ctx.stack.push(l + r) },

    _sub: 'Sub - subtracts two things off the stack and pushes the result. The larger one is normally the stack - 1',
    sub: ->(bc, ctx, _) { addend1 = ctx.stack.pop; addend2 = ctx.stack.pop; ctx.stack.push(addend2 - addend1) },

    _mult: 'Multiplies top 2 items off stack, pushes result.',
    mult: ->(bc, ctx, _) { addend1 = ctx.stack.pop; addend2 = ctx.stack.pop; ctx.stack.push(addend2 * addend1) },

    _div: 'Divides the top 2 items off stack, pushes the result.',
    div: ->(bc, ctx, _) { addend1 = ctx.stack.pop; addend2 = ctx.stack.pop; ctx.stack.push(addend2 / addend1) },

    _mod: 'Modulo, computes the modulo of the top 2 arguments on the stack and pushes the result',
    mod: ->(bc, ctx, _) { l, r = ctx.stack.pop(2); ctx.stack.push(l % r) },

    _exp: 'performs exponenation on top 2 items on stack, pushes the rsult',
    exp: ->(bc, ctx, _) { l, r = ctx.stack.pop(2); ctx.stack.push(l ** r) },

    # logical operators
    _and: 'Ands the top 2 items off the stack, pushes the result: true, false.',
    and: ->(bc, ctx, _) { v1, v2 = ctx.pop2; ctx.stack.push(v1 && v2) },

    _or: 'Ors the top 2 items off the stack, pushes the result: true or false.',
    or: ->(bc ,ctx, _) { v1, v2 = ctx.pop2; ctx.stack.push(v1 || v2) },

    _not: 'Negates the top 1 item off the stack, pushes the result: true or false.',
    not: ->(bc, ctx, _) { ctx.stack.push(! ctx.stack.pop) },

    # comparison operators
    _eq: 'Compares the top 2 items off the stack for equality, pushes the result: true or false.',
    eq: ->(bc, ctx, _) { v1, v2 = ctx.pop2; ctx.stack.push(v1 == v2) },

    _neq: 'Negates the meaning of equality of the top 2 items on the stack. Pushes true if  if they are inequal.',
    neq: ->(bc, ctx, _) { v1, v2 = ctx.pop2; ctx.stack.push(v1 != v2) },

    # assignments and dereferences
    _assign: 'assign - pop the name of the var, pop the value, store in ctx.vars.',
    assign: ->(bc, ctx, _) { var, val = ctx.stack.pop(2); ctx.vars[var] = val },


    # branching instructions
    _jmp: 'Jump to the value of the operand in the bytecode list.',
    jmp: ->(bc, ctx, _) { loc = bc.next; bc.pc = loc },

    _jmpt: 'branch if top of stack is true to the location contained in the operand of the bytecode list.',
    jmpt: ->(bc, ctx, _) { ex = ctx.stack.pop; loc = bc.next; bc.pc = loc if ex },
    _jmpf: 'Branch if top of stack is false to position of next operand',
        jmpf: ->(bc, ctx, _) { ex = ctx.stack.pop; loc = bc.next; bc.pc = loc if ! ex },

    # call stack manipulation :unwind, :pusht
    _unwind: 'Unwinds one object off call stack and pushes on interperter stack.',
    unwind: ->(bc, ctx, fr) do
      ftype= bc.next
      until (ftype == fr.peek) do
        fr.pop 
      end
    end,
    



  _icall: 'calls the builtin method on the top of the stack',
  icall: ->(bc, ctx, _) { 
    # get the symbol name of the builtin call
    meth = ctx.stack.pop
    # get the possible arg count
    argc = ctx.stack.pop
    argv = ctx.stack.pop(argc)
    ctx.stack.push(Dispatch.delegate(meth, *argv))
  },

    _str: 'Converts top of stack to a string, pushes the result',
    str: ->(bc, ctx, _) { ctx.stack.push(ctx.stack.pop.to_s) },

    # environment instructions : print, . .etc
    _print: 'Prints the top 1 item off the stack.',
    print: ->(bc, ctx, _) { value = ctx.stack.pop; $stdout.puts(value) },

    # flow control : :bcall, :bret, etc
    _bcall: 'pops name of block to jump to. . Pushes return location on call stack for eventual :bret opcode',
    bcall: ->(bc, ctx, fr) { 
      frame=BlockFrame.new
      frame.return_to = bc.pc
      fr.push(frame)
      var = ctx.stack.pop
      loc = ctx.vars[var.to_sym]
      bc.pc = loc 
    },
    _bret: 'pops return location off fr. jmps there',
    bret: ->(bc, ctx, fr) { frame = fr.pop; loc = frame.return_to; bc.pc = loc },
    _frame: 'Pushes Frame type on call stack',
    frame: ->(bc, ctx, fr) { frame = bc.next; fr.push frame },
    _fcall: 'Function call. Pushes FunctionFrame on fr. Loads parameters to functions in fr.ctx.stack',
    fcall: ->(bc, ctx, fr) {
     cx = Context.new
     cx.constants = ctx.constants
     argc = ctx.stack.pop
     argv = ctx.stack.pop(argc)
     cx.stack.push(*argv)
      frame = FunctionFrame.new(cx)
      # The return to should be one past the the operand
      frame.return_to = bc.pc + 1
          fr.push(frame) 
          target = bc.next
          bc.pc = target
    },

  # Lambda call stuff
  _lcall: 'Lambda call. Like :fcall, but with :bcall sugar sprinkled in',
    lcall: ->(bc, ctx, fr) {
      cx = Context.new
      cx.constants = ctx.constants
      ltype = ctx.stack.pop
      raise LambdaNotFound.new('unknown') if ! ltype.kind_of? LambdaType
      argc = ctx.stack.pop
      raise ArgumentError.new("Wrong number of parameters: #{argc} for #{ltype.arity}") if argc != ltype.arity
      argv = ctx.stack.pop(argc)
      cx.stack.push(*argv)
      frame = FunctionFrame.new(cx)
      frame.return_to = bc.pc
      fr.push(frame)
      bc.pc = ltype.target
    },
    _fret: 'Returns from function. Pops FunctionFrame off frames stack. Uses .return_to to return to calling code',
    fret: ->(bc, ctx, fr) {
      frame = fr.pop
      ret_val = frame.ctx.stack.pop
      fr.peek.ctx.stack.push ret_val
      bc.pc = frame.return_to
    },

    # machine low-level instructions: nop, halt, :int,  etc.


    _nop: 'Null operation.',
    nop: ->(bc, ctx, _) { },

    _halt: 'Halts the virtual machine.',
    halt: ->(bc, ctx, _) { raise HaltState.new },
    _exit: 'Early exit from program',
    exit: ->(bc, ctx, _) { raise ExitState.new },

  _int: 'Force an interrupt. Will cause interrupt handler to be called. The operand is the name(:symbol) of the handler to call. Normally :_default. bc.pc is incremented by one, in case an :iret is called in handler',
  int: ->(bc, ctx, _) { name = bc.codes[bc.pc]; bc.pc += 1; raise InterruptCalled.new(name) },
  _iret: 'Return from interrupt handler',
  iret: ->(bc, ctx, _) { raise InterruptReturn.new },

    # Debug opcodes
    _spy: 'Spies on the state of bytecodes, context.',
    spy: ->(bc, ctx, _) { puts 'bc:', bc.inspect; puts 'ctx:', ctx.inspect }
  }
end

def has_operand? code
  [:pushc, :pushv, :pushl, :jmp, :jmpt].member? code
end

def has_numeric_operand? code
  [:pushc, :jmp, :jmpt].member? code
end