# binding_type.rb - class  BindingType

class AssignmentDisallowed < VishRuntimeError
  #
end

# A BindingType is the representation of all scoped variable contexts
# Each binding is a PairType containing a symbol and and a value.
# The list of them forms a tree of binding sets
class BindingType
  include Type

  @@__TOP_LEVEL =  PairType.null
  def initialize bindings=@@__TOP_LEVEL
    @bindings =  bindings
  end
  def top_level
    @@__TOP_LEVEL
  end
  def root?(pair=@bindings)
    top_level == pair
  end
  alias_method :empty?, :root?

  attr_accessor :bindings
  def set(key, value)
    @bindings = PairType.new(key: PairType.new(key: key, value: value), value: @bindings)
  end
  def find_pair(key, rest=@bindings)
    if root?(rest)
      rest
    elsif rest.key.key == key
      rest.key
    else
      find_pair(key, rest.value)
    end
  end
  def set?(key)
    pair = find_pair(key)
    !root?(pair)
  end
  def dup
    self.class.new(@bindings)
  end
  def get key
    pair = find_pair key
    pair.value
  end

  def set!(key, value)
    if set?(key)
      pair = find_pair(key)
      pair.value = value
    else
      raise AssignmentDisallowed.new("Attempt to assign #{key}, but it was not defined")
    end
  end
  def [] key
    self.get(key)
  end
  def []= key, value
    if set? key
      self.set! key, value
    else
      self.set key, value
    end
  end
end
