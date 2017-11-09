# label.rb - class Label < Opcode - storage for location labels

class Label < Opcode
  def initialize name, opcode, operand=nil
    super opcode, operand
    @name = name.to_s
    @line, @col = name.line_and_column
    @connected = false
  end
  attr_reader :name, :line, :col

  def label?
    true
  end
  # find a matching target
  def ==(target)
    target.name == @name
  end
  def unconnected?
    ! @connected
  end

  def friend_me target
    @connected ||= (self == target)
  end

  def inspect
    "label #{@name} pc: #{@pc} @line #{@line}, col #{@col}"
  end
end
