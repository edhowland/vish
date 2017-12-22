# store_closure.rb - class StoreClosure < Terminal - Creates a closure at 
# runtime and stores on the heap

class StoreClosure < Terminal
  def initialize closure_id
    @closure_id = closure_id
  end
  attr_reader :closure_id
  attr_accessor :value
  def emit(bc, ctx)
    bc.codes << :storecl
    bc.codes << @value
    bc.codes << @closure_id
  end

  def inspect
    "#{self.class.name}: value: #{@value}, closure_id: #{@closure_id}"
  end
end
