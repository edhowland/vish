# string_interpolation.rb - class StringInterpolation < NonTerminal - holds
# double quoted strings.

class StringInterpolation < NonTerminal
  def initialize sequence
    @sequence = sequence
  end
  attr_accessor :sequence
  def emit(bc, ctx)
    # nop TODO: for now
  end
end
