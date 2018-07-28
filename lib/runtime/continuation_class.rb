# continuation.rb - class Continuation - captures currnet stack, bc.pc location

class Continuation < LambdaType
  def initialize stack, pc, frame, _binding
    @stack = stack
    @pc = pc
    @frame = frame
    @binding = _binding
  end
  attr_reader :pc, :stack, :frame, :binding

  def perform(intp)
#    puts "in Continuation.perform"
##    puts "stack: #{intp.ctx.stack.inspect}"
    # get the arg count and value
    argc = intp.ctx.stack.pop
    argv = intp.ctx.stack.pop
    # get passed in value
    intp.frames =  @frame
    intp.ctx.stack = @stack
    intp.ctx.stack.push argv
    intp.ctx.vars = @binding
#    puts "about to exit continuation: stack: #{intp.ctx.stack.inspect}, next pc will be #{@pc}"
    intp.bc.pc = @pc
  end
  def inspect
    "#{self.class.name}: pc: #{@pc}"
  end
end
