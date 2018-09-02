# lambda_type.rb - class LambdaType < Hash - replacement for LambdaType

class LambdaType < Hash
  include Type
  def initialize parms:, body:, _binding:, loc: nil
#    self[:parms] = parms
#    self[:body] = parms + body + [:fret]
    self[:formals] = parms
    self[:body] = body + [:fret]
    self[:binding] = _binding
    self[:loc] = loc
  self[:name] = :anonymous
  self[:doc] = :nodoc
  end

  def type
    self.class
  end
  # binding_dup - calls dup on behalf of optcode :ncall
  def binding_dup
    self[:binding].dup
  end
  # frame_from - move code from opcodes[:ncall] to here
  # frame_from - returns new FunctionFrame
  def frame_from(argc=0, ret=0)
    raise VishArgumentError.new(self[:arity], argc) if self[:arity] >= 0 and argc != self[:arity]
    fr = FunctionFrame.new(Context.new)
    fr.ctx.vars = binding_dup
    fr.return_to = ret
    fr
  end
  # check arity
  def check_arity(argc)
    raise VishArgumentError.new(self[:arity], argc) if self[:arity] != argc
  end
  def handle_variadic(argc, fr, argv=[])
    #
  end
  # tail_call: call from :tcall opcode. Does perform, but within existing stack
  # frame. Does bind the args to formals
  def tail_call(intp)
        argc = intp.ctx.stack.pop
    check_arity(argc)
    argv = intp.ctx.stack.pop(argc)
    fr = intp.frames.peek


    bn = binding_dup
    formals.zip(argv).each {|k, v| bn.set(k, v) }
    fr.ctx.vars = bn

#    handle_variadic(argc, fr, argv)

    # heere is where we differ
    intp.frames.peek.ctx.vars = bn
    intp.bc.pc = self[:loc]
  end

  # apply, was: perform lcall
  def perform(intp)
    argc = intp.ctx.stack.pop
    check_arity(argc)
    fr = FunctionFrame.new(Context.new)
    fr.return_to = intp.bc.pc
    argv = intp.ctx.stack.pop(argc)

    bn = binding_dup
    formals.zip(argv).each {|k, v| bn.set(k, v) }
    fr.ctx.vars = bn

    handle_variadic(argc, fr, argv)
    intp.frames.push fr
    # Now jump to start of function
    intp.bc.pc = self[:loc]
  end
  alias_method :apply, :perform
  def formals
#    c=(0..self[:arity]-1).to_a.map {|e| (e*5)+1}
#    c.each_with_object([]) {|e,o| o << self[:parms][e] }.reverse
    self[:formals]
  end

  def inspect
    "#{type.name}: loc: #{self[:loc]}"
  end
end
