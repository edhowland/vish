# interrupt_called.rb - class Interrupt < RuntimeError
# and descendants: InterruptCalled, InterruptReturn

class InterruptInterpreter < RuntimeError
  def initialize action 
    @action = action
    super "interrupt: #{@action.to_s}"
  end
  attr_reader :action
end

# Is raised in the case of CodeInterperter encountering an :int, :_name... opcode
class InterruptCalled < InterruptInterpreter
  def initialize name
    @name = name
    super :interrupt_entry
  end
  attr_reader :name
end

# InterruptReturn is raised if :iret is encountered
# It signals the method on the interpreter :interrupt_exit is to be called.
class InterruptReturn < InterruptInterpreter
  def initialize 
    super :interrupt_exit
  end
end
