# target.rb - class Target holds label

class Target
  def initialize name
    @name = name.to_s
    @pc = nil
  end
  attr_reader :name, :pc

  # locate! Label - makes @pc match Label
  def locate!(label)
    (!label.nil? && label.name == @name) && @pc = label.pc
    self
  end
  def unresolved?
    @pc.nil?
  end
  def inspect
    "label: #{@name}: #{@pc}"
  end
end
