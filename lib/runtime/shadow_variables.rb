# shadow_variables.rb - class ShadowVariables -  Used in Context for .vars member
# If, .push/.pop called, variables created with deeper stack will shadow
# variables created previously

class ShadowVariables
  def initialize
    @storage = [Hash.new(Undefined)]
  end
  def top
    @storage.last
  end
  def [](key)
    found = @storage.reverse.find {|h| h.key?(key) }
    found.nil? ? Undefined : found[key]
  end
  def []=(key, value)
    top[key] = value
  end
  def push
    @storage.push Hash.new(Undefined)
  end
  def pop
    @storage.pop
  end
end
