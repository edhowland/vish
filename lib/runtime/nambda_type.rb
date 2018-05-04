# nambda_type.rb - class NambdaType < Hash - replacement for LambdaType
# TODO: rename me to LambdaType

class NambdaType < Hash
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

  def inspect
    "#{type.name}: loc: #{self[:loc]}"
  end
end
