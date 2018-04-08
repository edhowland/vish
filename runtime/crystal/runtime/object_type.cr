# object_type.rb - class ObjectType < Hash

module ObjectType
  include Type
  def type
    ObjectType
  end
  def +(that)
    self.merge(that)
  end
end


# Constructs a Hash extended with ObjectType out of array of PairTypes
class ObjectFactory
  def self.build pairs=[]
    raise PairInvalidArgumentType.new unless pairs.all? {|e| e.respond_to?(:type) && e.type == PairType }
    this = {}
    this.extend(ObjectType)
    pairs.each_with_object(this) { |e, o| o[e.key] = e.value }
  end
end
