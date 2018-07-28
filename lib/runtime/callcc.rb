# callcc.rb - class Callcc < LambdaType - Implements internal callcc function
# implements the call-with-current-continuation function (like from Scheme)
# call/cc - takes a lambda of one parameter - the Continuation object.
# callcc, when :lcall'ed, will create a new Continuation object and push
# on the stack

class CallCC < LambdaType
  def initialize
    super parms: [], body: [], _binding: nil
  end
  def perform(intp)
    raise VishArgumentError.new(1, intp.ctx.stack.peek) unless intp.ctx.stack.peek == 1
    intp.ctx.stack.pop
    ltype = intp.ctx.stack.pop
    raise VishTypeError.new "callcc expects argument of LambdaType, got #{ltype.class.name}" unless ltype.kind_of?(LambdaType)
    raise VishRuntimeError.new "callcc expects lambda of 1 parameter, got #{ltype[:arity]}" unless ltype[:arity] == 1

#    puts "return to #{intp.frames.peek.return_to}"

    # psuedo - code
    bn = intp.ctx.vars.dup
    # Continuation.new ...
    k = Continuation.new intp.ctx.stack, intp.bc.pc, intp.frames,bn
    fr = FunctionFrame.new(Context.new)
# IGNORE:    # Create our own Frame, set intp.bc.pc in return_to
    # Create ltype's new Frame, sets same return_to, _binding.dup, 
    # assign Continuation from above in frame.ctx.vars - new binding

    fr.return_to = intp.bc.pc
    fr.ctx.vars = bn
    fr.ctx.vars[ltype[:formals][0]] = k
    intp.frames.push fr
# IGNORE    # push Cont. and argc=1 on current top of stack
    # set intp.bc.pc to ltype[:loc]
    intp.bc.pc = ltype[:loc]

#    intp.ctx.stack.push 98
  end
end
