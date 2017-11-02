# funcall.rb - class  Funcall < NonTerminal
# TODO: Remove the following note:
# Used to test out class SimpleTransform. Rule should return one of these objects
# Or it should be added to a tree (AST)

class Funcall < NonTerminal
  def initialize name, arglist
    @name = name
    @arglist = arglist
  end
  attr_reader :name, :arglist
  def inspect
    "#{@name} : #{@arglist.inspect}"
  end
end
