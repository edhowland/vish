# target.rb - class Target holds label

class Target
  def initialize name
    @name = name
    @pc = nil
  end
  attr_reader :name, :pc

  # locate! Label - makes @pc match Label
  def locate!(label)
    label.name == @name && @pc = label.pc
    self
  end
end