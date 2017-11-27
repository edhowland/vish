# limited_stack.rb - class LimitedStack - stack that cannot grow unbounded

class StackLimitReached < RuntimeError
  def initialize 
    super 'Stack limit reached. Are you being called in an infinite recursion?'
  end
end

class LimitedStack < Array
  def initialize limit:
    @limit = limit
  end
  attr_reader :limit

  def push(arg)
    raise StackLimitReached.new if self.length >= @limit
    super
  end
  
  def peek
    self[-1]
  end
end