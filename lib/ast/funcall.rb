# funcall.rb - class  Funcall < NonTerminal

# Funcall takes the name of the function to call. Later, the arg count :argc
# maybe added by FunctorNode
class Funcall < NonTerminal
  def initialize name
    @name = name.to_sym
    @argc = 0
  end
  attr_reader :name
  attr_accessor :argc

  def emit(bc, ctx)
  loc = ctx.store_constant @argc
  # The number of arguments currently on the stack
  bc.codes << :pushc
  bc.codes << loc
    bc.codes << :pushl
    bc.codes << @name
    bc.codes << :icall
  end
  def inspect
    "funcall: #{@name}"
  end
end
