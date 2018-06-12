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

  def inspect
    "#{type.name}: loc: #{self[:loc]}"
  end
end
