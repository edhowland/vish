# lambda_type.rb - class LambdaType < Hash - replacement for LambdaType

class LambdaType < Hash
  include Type
  def initialize parms:, body:, _binding:, loc: nil
    self[:parms] = parms
    self[:body] = parms + body + [:fret]
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

  def inspect
    "#{type.name}: loc: #{self[:loc]}"
  end
end
