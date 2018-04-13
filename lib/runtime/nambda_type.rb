# nambda_type.rb - class NambdaType < Hash - replacement for LambdaType
# TODO: rename me to LambdaType

class NambdaType < Hash
  include Type
  def initialize parms, body, binding, loc=nil
    self[:parms] = []
    self[:body] = body + [:fret]
    self[:binding] = binding
    self[:loc] = loc
  end

  def type
    self.class
  end
end
