# context.rb - class  Context - scratchpad for constants, stack, vars, .etc


class Context
  def initialize
    @stack = []
    @constants = []
  end
  attr_accessor :stack, :constants
  
  def store_constant(value)
    @constants << value
    @constants.length - 1
  end
end
