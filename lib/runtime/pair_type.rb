# pair_type.rb - class PairType - tuple of SymbolType and lambda or expression

class PairLengthError < VishRuntimeError
end

class PairType < Array
  include Type
  def initialize _array=[nil, nil]
    raise PairLengthError if _array.length != 2
    super(2)
    self.send :[]=,0,_array[0]
    self.send :[]=,1,_array[1]
  end
end
