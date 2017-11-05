# label.rb - class Label < Opcode - storage for location labels

class Label < Opcode
  def initialize name, opcode, operand=nil
    super opcode, operand
    @name = name.to_s
  end
  attr_reader :name

  def label?
    true
  end
end
