# lambda_call.rb - class LambdaCall < NonTerminal - Implements a call to a
# lambda. - E.g. if x is ->() { 1 ); Then %x() is this class

class LambdaCall < NonTerminal
  # new - Initializes LambdaCall with name of variable
  # lm=->() { 1}; %lm(1)
  # Parameters:
  # - name - name of variable : (like :lm above)
  def initialize name
    @name = name.to_s.to_sym
    @argc = 0
  end
  attr_reader :name
  attr_accessor :argc

  # emit - outputs count of arguments on stack. (Already there by the time we
  #  get there.) Then emits variable dereference
  def emit(bc, ctx)
    loc = ctx.store_constant(@argc)
    bc.codes << :pushc
    bc.codes << loc
    # TODO: Think this is wrong
    bc.codes << :pushv
    bc.codes << @name
    # Get the item off the heap and push on stack
    bc.codes << :pusha
    bc.codes << :lcall
  end

  def inspect
    "#{self.class.name}: name: #{@name}, argc: #{@argc}"
  end
end