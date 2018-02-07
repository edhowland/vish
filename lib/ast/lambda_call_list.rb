# lambda_call_list.rb - class LambdaCallList < NonTerminal - AST node for parsed
# %list[id(0)] ...

# LambdaCallList 
# subtree top for FunctorNode -like DerefList
# But emits different bytecode because LambdaType pointer to heap of closure
# is already on the top of the stack
class LambdaCallList < NonTerminal
  def self.subtree(functor)
    top = mknode(self.new)
    top << node_unless(functor)

    top
  end

  def emit(bc, ctx)
    # Already should have :Lambda_type_XXXX on top of stack
    # ??? what to do about additional args
    bc.codes <<  :pushl
    bc.codes << 0
    # need to swap the top args to get in the right order
    bc.codes << :swp
    bc.codes << :pusha
    bc.codes << :lcall
  end

  def inspect
    "#{self.class.name}"
  end
end
