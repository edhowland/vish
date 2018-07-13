# opcodes.rb - Hash of lambdas representing various opcodes
# Must : Keep has_operand? code up-to-date when adding things here : @ end file
# opcodes - returns hash of opcodes
# Parameters:
# tmpreg - storage in temporary register
def opcodes tmpreg=nil
  {
    _cls: ' Clear the stack. Used at start of every statement.',
    cls: ->(bc, ctx, _, intp) { ctx.clear },

    _pushc: 'pushc - Pushes value of indexed constant',
    pushc: ->(bc, ctx, _, intp) { i = bc.next; ctx.stack.push ctx.constants[i] },

    _pushv: 'pushv : Pushes value of named variable',
    pushv: ->(bc, ctx, _, intp) {
      var = bc.next
      ctx.stack.push(ctx.vars[var]) 
    },

    _pushl: 'pushl - Pushes literal of LValue on stack',
    pushl: ->(bc, ctx, _, intp) { var = bc.next; ctx.stack.push(var) },
  _pusht: 'Pushes the contents of tmpreg onto the stack.',
  pusht: ->(bc, ctx, _, intp) { ctx.stack.push(tmpreg.store) },

    # LambdaType stuff
    _alloc: 'Allocates top of stack, places it on heap, pushes its genid back on stack',
    alloc: ->(bc, ctx, fr, intp) {
      value = ctx.stack.pop
      id = genid(value)
#      id.extend(LambdaFunction)
      intp.heap[id] = value
      ctx.stack.push id
    },
    _pusha: 'Uses top of stack as pointer to value on heap, pushes value back on stack',
    pusha: ->(bc, ctx, fr, intp) {
      id = ctx.stack.pop
      value = intp.heap[id]
      ctx.stack.push value
    },

    # Closure stuff
    # :clone - prepares a new instance of probably LambdaType on top of stack
    _clone: 'Clones the top of stack and pushes back on stack',
    clone: ->(bc, ctx, fr, intp) { ctx.stack.push(ctx.stack.pop.clone) },
    _savefp: 'Finds the nearest UnionFrame on the call stack and saves it on LambdaType on top of data stack',
    savefp: ->(bc, ctx, fr, intp) {
    frame = fr.reverse.find {|f| UnionFrame === f}
      ctx.stack.peek.binding = frame.ctx.vars
        },


    _loadt: 'Loads top of stack into tmpreg (temporary register).',
    loadt: ->(bc, ctx, _, intp) { tmpreg.load(ctx.stack.pop) },
    _dup: 'Duplicates the top of the stack and pushes the copy back there.',
    dup: ->(bc, ctx, _, intp) { ctx.stack.push(ctx.stack.peek) },
    _swp: 'Swaps top 2 items on stack',
    swp: ->(bc, ctx, fr, intp) { ctx.stack.swap },
    _drop: 'Drops the top of stack',
    drop: ->(bc, ctx, fr, intp) { ctx.stack.pop unless ctx.stack.empty? },
    # Arithmetic instructions.
    _add:  'Add - BinararyAdd - pops 2 operands and pushes the result of adding them',
    add: ->(bc, ctx, _, intp) { l,r = ctx.stack.pop(2); ctx.stack.push(l + r) },

    _sub: 'Sub - subtracts two things off the stack and pushes the result. The larger one is normally the stack - 1',
    sub: ->(bc, ctx, _, intp) { addend1 = ctx.stack.pop; addend2 = ctx.stack.pop; ctx.stack.push(addend2 - addend1) },

    _mult: 'Multiplies top 2 items off stack, pushes result.',
    mult: ->(bc, ctx, _, intp) { addend1 = ctx.stack.pop; addend2 = ctx.stack.pop; ctx.stack.push(addend2 * addend1) },

    _div: 'Divides the top 2 items off stack, pushes the result.',
    div: ->(bc, ctx, _, intp) { addend1 = ctx.stack.pop; addend2 = ctx.stack.pop; ctx.stack.push(addend2 / addend1) },

    _mod: 'Modulo, computes the modulo of the top 2 arguments on the stack and pushes the result',
    mod: ->(bc, ctx, _, intp) { l, r = ctx.stack.pop(2); ctx.stack.push(l % r) },

    _exp: 'performs exponenation on top 2 items on stack, pushes the rsult',
    exp: ->(bc, ctx, _, intp) { l, r = ctx.stack.pop(2); ctx.stack.push(l ** r) },

    # logical operators
    _and: 'Ands the top 2 items off the stack, pushes the result: true, false.',
    and: ->(bc, ctx, _, intp) { v1, v2 = ctx.pop2; ctx.stack.push(v1 && v2) },

    _or: 'Ors the top 2 items off the stack, pushes the result: true or false.',
    or: ->(bc ,ctx, _, intp) { v1, v2 = ctx.pop2; ctx.stack.push(v1 || v2) },

    _not: 'Negates the top 1 item off the stack, pushes the result: true or false.',
    not: ->(bc, ctx, _, int) { ctx.stack.push(! ctx.stack.pop) },
    _negate: 'unary negation arithmetic of top of stack, pushes result',
    negate: ->(bc, ctx, _, _) { l = ctx.stack.pop; ctx.stack.push((-(l))) },

    # comparison operators
    _eq: 'Compares the top 2 items off the stack for equality, pushes the result: true or false.',
    eq: ->(bc, ctx, _, intp) { v1, v2 = ctx.pop2; ctx.stack.push(v1 == v2) },

    _neq: 'Negates the meaning of equality of the top 2 items on the stack. Pushes true if  if they are inequal.',
    neq: ->(bc, ctx, _, intp) { v1, v2 = ctx.pop2; ctx.stack.push(v1 != v2) },

    _less: 'pops the top 2 items off stack, comparse for less than, pushes result',
    less: ->(bc, ctx, _, intp) { l1, l2 = ctx.stack.pop(2); ctx.stack.push(l1 < l2) },
    _lte: 'pushes result of top 2 items off stack if less than or equal',
    lte: ->(bc, ctx, _, _) { l1, l2 = ctx.stack.pop(2); ctx.stack.push(l1 <= l2) },
    _greater: 'pushes result of > top 2 items off stack',
    greater: ->(bc, ctx, _, _) { l1, l2 = ctx.stack.pop(2); ctx.stack.push(l1 > l2) },
    _gte: 'pushes result of >= top 2 items off stack',
    gte: ->(bc, ctx, _, _) { l1, l2 = ctx.stack.pop(2); ctx.stack.push(l1 >= l2) },
    # assignments and dereferences
    _assign: 'assign - pop the name of the var, pop the value, store in ctx.vars.',
    assign: ->(bc, ctx, _, intp) {
      var, val = ctx.stack.pop(2)
      ctx.vars[var] = val 
      ctx.stack.push val
    },
    _assignx: 'Assigns a value to object, a vector or hash, via the .[]= method',
    assignx: ->(bc,ctx, fr, intp) {
      object, index, val = ctx.stack.pop(3)
      result = object.[]=(index, val)
      ctx.stack.push result
    },
    _index: 'Pushes value of index of object, either hash or vector',
    index: ->(bc, ctx, fr, intp) {
      object, ndx = ctx.stack.pop(2)
      result = object.[](ndx)
      ctx.stack.push result
    },
    _set: 'Sets a new value in context vars binding, possibly shadowing other values',
    set: ->(bc, ctx, fr, intp) {
            var, val = ctx.stack.pop(2)
            ctx.vars.set(var, val)
      ctx.stack.push val
    },


    # branching instructions
    _jmp: 'Jump to the value of the operand in the bytecode list.',
    jmp: ->(bc, ctx, _, intp) { loc = bc.next; bc.pc = loc },

    _jmpt: 'branch if top of stack is true to the location contained in the operand of the bytecode list.',
    jmpt: ->(bc, ctx, _, intp) { ex = ctx.stack.pop; loc = bc.next; bc.pc = loc if ex },
    _jmpf: 'Branch if top of stack is false to position of next operand',
        jmpf: ->(bc, ctx, _, intp) { ex = ctx.stack.pop; loc = bc.next; bc.pc = loc if ! ex },

    _jmpr: 'Jump relative. Jumps to bytecode position relative to this opcode',
    jmpr: ->(bc,ctx, fr, intp) {
      _curr = bc.pc
            _loc = bc.next
      bc.pc = _curr + _loc
    },
    _jmprt: 'Jumps relative to this position if top of stack true',
    jmprt: ->(bc, ctx, fr, intp) {
  val = ctx.stack.pop
                  _loc = bc.next
      if val
              _curr = bc.pc
        bc.pc = _curr + _loc - 1
       end
    },
    _jmprf: 'Jumps relative from here if top of stack is false',
    jmprf: ->(bc, ctx, fr, intp) {
          val = ctx.stack.pop
              _loc = bc.next
      unless val
                    _curr = bc.pc
        bc.pc = _curr + _loc - 1
      end
    },

    # call stack manipulation :unwind, :pusht
    _unwind: 'Unwinds one object off call stack and pushes on interperter stack.',
    unwind: ->(bc, ctx, fr, intp) do
      ftype= bc.next
      until (ftype === fr.peek) do
        fr.pop 
      end
    end,
    



  _icall: 'calls the builtin method on the top of the stack',
  icall: ->(bc, ctx, _, intp) { 
    # get the symbol name of the builtin call
    meth = ctx.stack.pop
    # get the possible arg count
    argc = ctx.stack.pop
    argv = ctx.stack.pop(argc)
    ctx.stack.push(Dispatch.delegate(meth, *argv))
  },

    _str: 'Converts top of stack to a string, pushes the result',
    str: ->(bc, ctx, _, intp) { ctx.stack.push(ctx.stack.pop.to_s) },

    # environment instructions : print, . .etc
    _print: 'Prints the top 1 item off the stack.',
    print: ->(bc, ctx, _, intp) { value = ctx.stack.pop; $stdout.puts(value) },

    # flow control :  :bret, etc

    _bret: 'pops return location off fr. jmps there',
    bret: ->(bc, ctx, fr, intp) {
      frame = fr.pop
      loc = frame.return_to
      bc.pc = loc 
    },
#    _frame: 'Pushes Frame type on call stack',
#    frame: ->(bc, ctx, fr, intp) { frame = bc.next; fr.push frame },


  # Lambda call stuff


    _fret: 'Returns from function. Pops FunctionFrame off frames stack. Uses .return_to to return to calling code',
    fret: ->(bc, ctx, fr, intp) {
      frame = fr.pop
      ret_val = frame.ctx.stack.safe_pop
      fr.peek.ctx.stack.push ret_val
      bc.pc = frame.return_to
      frame.pop_retto
    },

    # New version of  lcall: TODO. rename this to :lcall, remove old :lcall
    _lcall: 'Pops LambdaType object, hands interpreter to it to perform call',
    lcall: ->(bc, ctx, fr, intp) {
      ltype = ctx.stack.pop
      raise LambdaNotFound.new('unknown') if ! ltype.kind_of? LambdaType
      ltype.perform(intp)
    },
    _tcall: 'Tail call version of :lcall',
    tcall: ->(bc, ctx, fr, intp) {
          ltype = ctx.stack.pop
      raise LambdaNotFound.new('unknown') if ! ltype.kind_of? LambdaType
      ltype.tail_call(intp)
    },

    # machine low-level instructions: nop, halt, :int,  etc.
    _frame: 'Pushes frame stack onto data stack',
    frame: ->(bc, ctx, fr, intp) { ctx.stack.push(fr) },

    _send: 'Sends the message in opcode to object on stop of stack, pushes result onto stack',
    send: ->(bc, ctx, fr, intp) {
      obj = ctx.stack.pop
      msg = bc.next
      if obj.respond_to?(msg)
        ctx.stack.push(obj.send(msg))
      else
        raise VishRuntimeError.new "Object #{obj.class.naem} does not respond to #{msg}"
      end
    },

    _nop: 'Null operation.',
    nop: ->(bc, ctx, _, intp) { },

    _halt: 'Halts the virtual machine.',
    halt: ->(bc, ctx, _, intp) { raise HaltState.new },
    _exit: 'Early exit from program',
    exit: ->(bc, ctx, _, intp) { raise ExitState.new },

  _int: 'Force an interrupt. Will cause interrupt handler to be called. The operand is the name(:symbol) of the handler to call. Normally :_default. bc.pc is incremented by one, in case an :iret is called in handler',
  int: ->(bc, ctx, _, intp) { name = bc.codes[bc.pc]; bc.pc += 1; raise InterruptCalled.new(name) },
  _iret: 'Return from interrupt handler',
  iret: ->(bc, ctx, _, intp) { raise InterruptReturn.new },

  }
end

def has_operand? code
  [:pushc, :pushv, :pushl, :jmp, :jmpt].member? code
end

def has_numeric_operand? code
  [:pushc, :jmp, :jmpt].member? code
end