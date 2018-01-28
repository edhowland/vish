# pair_type.rb - class PairType - tuple of SymbolType and lambda or expression

class PairInvalidArgumentType < VishRuntimeError
end

class PairType
  include Type
  def initialize key:, value:
    @key, @value = key, value
  end
  attr_reader :key, :value
  def inspect
    "#{self.class.name}: key: #{@key.inspect} value: #{@value.inspect}"
  end
end