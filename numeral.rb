# numeral.rb - class  Numeral < Terminal - holds a number

class Numeral < Terminal
  def emit(bc, ctx)
    bc << :pushc
    bc << ctx.store_constant(@value)
  end
end
