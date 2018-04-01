# lvalue.rb - class  LValue - represents value left of assignment
# E.g. num = 1  : The 'num' is the LValue

 class LValue < Terminal

  def emit(bc, ctx)
    bc << :pushl
    bc.codes << @value.to_sym
  end

  def inspect
    "#{self.class.name}: #{@value}"
  end
 end 
