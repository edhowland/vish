# string_literal.rb - class StringLiteral < Terminal - holder for strings

class StringLiteral < Terminal
  def initialize slice
    super slice.to_s
  end

  def emit(bc, ctx)
    bc.codes << :pushc
    bc << ctx.store_constant(@value)
  end
  def to_s
    @value.to_s
  end
end
