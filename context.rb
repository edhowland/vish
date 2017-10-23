# context.rb - class  Context - scratchpad for constants, stack, vars, .etc


class Context
  def initialize
    @stack = []
    @constants = []
  end
  attr_accessor :stack, :constants
end