# lambda_call_list.rb - class LambdaCallList < NonTerminal - AST node for parsed
# %list[id(0)] ...

# LambdaCallList 
# subtree top for FunctorNode -like DerefList
# But emits different bytecode because LambdaType pointer to heap of closure
# is already on the top of the stack
class LambdaCallList < NonTerminal
  def initialize argc=0
    @argc = argc
    super()
  end

  def self.subtree(functor, lambda_args=[])
    lambda_args.reject!(&:nil?)
    top = mknode(self.new(lambda_args.length))
    lambda_args.each do |arg|
      top << node_unless(arg)
    end
    top << node_unless(functor)

    top
  end

  def emit(bc, ctx)
    # Should have any evaluated arguments to this function ahead of the deref'ed list
    # Already should have :Lambda_type_XXXX on top of stack
    argc = ctx.store_constant(@argc)
    bc.codes <<  :pushc
    bc.codes << argc
    # need to swap the top args to get in the right order
    bc.codes << :swp
    bc.codes << :pusha
    bc.codes << :lcall
  end

  def inspect
    "#{self.class.name}: argc: #{@argc}"
  end
end
