# funcall.rb - class  Funcall < NonTerminal
# TODO: Remove the following note:
# Used to test out class SimpleTransform. Rule should return one of these objects
# Or it should be added to a tree (AST)

class Funcall < NonTerminal
  def initialize name, arglist
    @name = name.to_sym
    @arglist = arglist
  end
  attr_reader :name, :arglist

  def emit(bc, ctx)
    bc.codes << :pushl
    bc.codes << @name
    bc.codes << :icall
  end
  def inspect
    "#{@name} : #{@arglist.inspect}"
  end
end
