# terminal.rb - class  Terminal - as in a AST sense - Base class for terminals

class Terminal
  def initialize value=nil
    @value = value
  end
  attr_reader :value

  def emit(bc, ctx)
    raise 'Invalid call to base class Terminal#emit'
  end

  def inspect
    "#{self.class.name}: value: #{@value}"
  end
end