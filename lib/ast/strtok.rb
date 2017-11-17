# strtok.rb - class Strtok < Terminal - represents a part of a string

class Strtok < Terminal
  def initialize strtok
    @value = strtok.to_s
  end
  def emit(bc, ctx)
    # NOP
  end
end