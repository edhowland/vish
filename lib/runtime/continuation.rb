# continuation.rb - module Continuation : mixin to LambdaType
# meant to extend existing lambda object

module Continuation
  def perform(intp)
#    argv, argc = intp.ctx.stack.pop(2)
#    intp.frames = self[:frames]
#    intp.ctx.stack.push argv, argc
#    puts "argc: #{argc}, argv: #{argv}"
    super(intp)
  end
  def type
    Continuation
  end
end
