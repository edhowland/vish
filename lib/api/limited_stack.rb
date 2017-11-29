# limited_stack.rb - class LimitedStack - stack that cannot grow unbounded

# class  StackLimitReached - raised when LimitedStack hits overflow past its enforced limit:
class StackLimitReached < RuntimeError
  def initialize 
    super 'Stack limit reached. Are you being called in an infinite recursion?'
  end
end

class StackUnderflow < RuntimeError
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

  def push(arg)
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
    raise StackUnderflow.new if self.length <= 0
    super
  end
end