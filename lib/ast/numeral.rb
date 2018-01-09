# numeral.rb - class  Numeral < Terminal - holds a number

class Numeral < Terminal
  def emit(bc, ctx)
    bc << :pushc
    bc << ctx.store_constant(@value.to_i)
  end


  def to_i
    @value.to_i
  end
  def inspect
    "#{self.class.name}: #{@value.to_i}"
  end
end
