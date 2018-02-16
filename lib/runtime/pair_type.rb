# pair_type.rb - class PairType - tuple of SymbolType and lambda or expression

class PairInvalidArgumentType < VishRuntimeError
end

class PairType
  include Type
  def initialize key:, value:
    @key, @value = key, value
  end
  attr_reader :key, :value
  def self.null
    self.new key: Undefined, value: Undefined
  end
  def self.null?(other)
    other.key == Undefined && other.value == Undefined
  end
  def value=(value)
    @value = value
  end
  def inspect
    "#{self.class.name}: key: #{@key.inspect} value: #{@value.inspect}"
  end
  def ==(other)
    self.key == other.key && self.value == other.value
  end
  def to_a
    [@key, @value]
  end
end
