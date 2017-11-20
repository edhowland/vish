# string_interpolation.rb - class StringInterpolation < NonTerminal - holds
# double quoted strings.

def stringlit_or_other thing
  String === thing ? StringLiteral.new(thing) : thing
end

class StringInterpolation < NonTerminal
  # convert the passed in array into a string or a thing that be converted
  # into a string. Like a :{ vish_expr } sequence. See StringExpr
  def initialize sequence
    @sequence = sequence
    @value = @sequence.map(&:to_s).join('')
  end
  attr_accessor :sequence

  def self.subtree(sequence)
    inter =  rl_compress(sequence) {|e| !(e.instance_of?(StringLiteral) || e.instance_of?(EscapeSequence)) }
    inter2 = array_join(inter, :+)
#binding.pry
    rdp = SimpleRDP.new(inter2, default: StringLiteral.new(''), 
      term_p: ->(v) { stringlit_or_other(v) },
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
