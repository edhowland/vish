# lvalue.rb - class  LValue - represents value left of assignment
# E.g. num = 1  : The 'num' is the LValue

 class LValue < Terminal

  def emit(bc, ctx)
    bc << :pushv
    bc << ctx.store_var(@value)
  end

  def inspect
    "#{self.class.name}: #{@value}"
  end
 end 
