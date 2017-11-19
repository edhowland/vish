# string_interpolation.rb - class StringInterpolation < NonTerminal - holds
# double quoted strings.

class StringInterpolation < NonTerminal
  # convert the passed in array into a string or a thing that be converted
  # into a string. Like a :{ vish_expr } sequence. See StringExpr
  def initialize sequence
    @sequence = sequence
    @value = @sequence.map(&:to_s).join('')
  end
  attr_accessor :sequence

  def self.subtree(sequence)
    rdp = SimpleRDP.new(array_join(sequence, :+), default: '', 
      term_p: ->(v) { v },
      nont_p: ->(o, l, r) { ArithmeticFactory.subtree(o, l, r) })
    rdp.run
    rdp.last
  end
  def emit(bc, ctx)
    loc = ctx.store_constant(@value)
    bc.codes << :pushc
    bc.codes << loc
  end
end
