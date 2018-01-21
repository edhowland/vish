# object_type.rb - class ObjectType < Hash

class ObjectType < Hash
  include Type
  def initialize _hash={}
    super()
    self.merge(_hash)
  end
end
