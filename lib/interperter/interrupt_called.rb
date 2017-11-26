# interrupt_called.rb - class InterruptCalled < RuntimeError

# Is raised in the case of CodeInterperter encountering an :int, :_name... opcode
class InterruptCalled < RuntimeError
  def initialize name
    @name = name
    super "Interrupt called with handler name: #{@name}"
  end
  attr_reader :name
end
