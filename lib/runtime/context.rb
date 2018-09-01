# context.rb - class  Context - scratchpad for constants, stack, vars, .etc

# This value is stored before any assignment(s)
Undefined = 'undefined'

class Context
  def initialize
    @stack = LimitedStack.new(limit:1000)
    @constants = []
    @vars = BindingType.new   #ShadowVariables.new
  end
  attr_accessor :stack, :constants, :vars

  # store_constant value : loads the value into @constants and returns its offset
  # TODO: Improve this by finding an exact match and returning that offset
  # This will allow for a small optimization in file size
  def store_constant(value)
    @constants << value
    @constants.length - 1
  end
  # clear the stack. Presumably at start of statement
  def clear
    @stack.clear
  end
  
  # pop 2 items off stack
  def pop2
    return @stack.pop, @stack.pop
  end

  def store_var(key, value=Undefined)
    actual = key.to_sym
    @vars[actual] = value
    actual
  end


  def inspect
    "constants: #{@constants.inspect}\nVariables: #{@vars.inspect}\nstack: #{@stack.inspect}\n"
  end
  def _clone
    result = self.class.new
    result.constants = @constants.clone
    result.stack = Builtins.clone(@stack)
    result.vars = self.vars.dup
    result
  end
  def to_h
    {stack: @stack, constants: @constants, vars: @vars }
  end
end
