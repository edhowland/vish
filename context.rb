# context.rb - class  Context - scratchpad for constants, stack, vars, .etc


# This value is stored before any assignment(s)
Undefined = 0xff

class Context
  def initialize
    @stack = []
    @constants = []
    @vars = {}
  end
  attr_accessor :stack, :constants, :vars

  def store_constant(value)
    @constants << value
    @constants.length - 1
  end

  def store_var(key, value=Undefined)
    actual = key.to_sym
    @vars[actual] = value
    actual
  end
end
