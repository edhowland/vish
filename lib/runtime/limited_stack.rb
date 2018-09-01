# limited_stack.rb - class LimitedStack - stack that cannot grow unbounded
# Also adds LockedStack child. - Provides ability to lock bottom
# of stack from being popped. Can hold onto underlying MainFrame.

# base class of stacks errors
class StackError < VishRuntimeError; end


# class  StackLimitReached - raised when LimitedStack hits overflow past its enforced limit:
class StackLimitReached < StackError
  def initialize 
    super 'Stack limit reached. Are you being called in an infinite recursion?'
  end
end

class StackUnderflow < StackError
  def initialize 
    super 'LimitedStack has reached its lower limit. No more pop calls can be made'
  end
end
# class LimitedStack - a stack with limits on push, pop
class LimitedStack < Array
  # new - Creates a new stack with limit: allowed size maximum
  # returns LimitedStack
  def initialize limit:
    @limit = limit
  end
  attr_reader :limit
  alias_method :old_pop, :pop

  def push(*arg)
    raise StackLimitReached.new if self.length >= @limit
    super
  end
  # peek - peeks at the top of the stack
  def peek
    self[-1]
  end

  # pop - pops the number off the top of the stack
  # Parameters:
  # (optional) count to pop Default: 1
  def pop(*args)
    raise StackUnderflow.new if self.length <= 0 && !(args.length > 0 && args.first.zero?)
    super
  end
  def safe_pop(*args)
#    old_pop
if self.empty?
  nil
else
  pop(*args)
end
  end
  # swap - reverses top 2 items on stack
  def swap
    return nil if self.length < 2
    a, b = pop(2)
    push(b, a)
  end
  # return previous frame: the penultimate one
  def previous
    raise VishRuntimeError.new('Cannot return previous frame, bottom of stack reached.') unless self.length > 1
    self[-2]
  end
  def _clone
    result = self.class.new limit: @limit
    self.each {|f| result.push Builtins.clone(f) }
    result
  end
end

class LockedStackLimitReached < StackError
  def initialize
    super 'Internal Error:. An attempt to pop the locked framehappened.'
  end
end

class LockedStack < LimitedStack
  def pop(*args)
    raise LockedStackLimitReached.new if self.length <= 1
    super
  end
end