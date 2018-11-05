# binding_type.rb - class  BindingType

class AssignmentDisallowed < VishRuntimeError
  #
end

# A BindingType is the representation of all scoped variable contexts
# Each binding is a PairType containing a symbol and and a value.
# The list of them forms a tree of binding sets
class BindingType
  include Type

  def initialize bindings=NullType.new  
    @bindings =  bindings
  end

  def root?(pair=@bindings)
    bnull?(pair)
  end
  alias_method :empty?, :root?

  attr_accessor :bindings
  def set(key, value)
    @bindings = PairType.new(key: PairType.new(key: key, value: value), value: @bindings)
  end

  # walk - walk the list of nodes
  def walk(rest=@bindings, &blk)
    if root?(rest)
      rest
    else
      yield rest.key if block_given?
      walk(rest.value, &blk)
    end
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
  def variables
    result = []
    walk {|pt| result << pt.to_a }
    result
  end
  # get the number of defined variables. Includes all lambdas, esp. proxies for
  # builtin and FFI functions
  def bnull?(b)
    b.instance_of?(NullType)
  end

  def length(b=@bindings, result=0)
    return 0 if bnull?(b)
    1 + length(b.value, result)
  end

  # Displays the type of this object: BindingType
  # To get contents, do xmit(binding(), variables:) in Vish ivs REPL
  def inspect
    "#{self.class.name} length: #{length}"
  end
  def xinspect
    @bindings.xinspect
  end
  def exist?(key)
    attempt = find_pair(key)
    ! root?(attempt)
  end
end
