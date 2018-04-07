# vector_type.rb - class VectorType - wraps Array


module VectorType
  include Type
  def type
    VectorType
  end
end
# constructs VectorType from array
class VectorFactory
  def self.build(array=[])
    array.extend VectorType
    array
  end
end
