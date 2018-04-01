# null_type.rb - class  NullType - tail of list pairs
#
# list=foo: (bar: (baz: null))
# depends on null keyword syntax


class NullType < PairType
  include Type
  def initialize
    super(key: Undefined, value: Undefined)

  end
  def inspect
    '()'
  end
end
