# strtok.rb - class Strtok < Terminal - represents a part of a string

class Strtok < Terminal
  def initialize strtok
    @value = strtok.to_s
  end
  def emit(bc, ctx)
    # NOP
  end

  # :to_s just return @value.to_s to comply with needs of StringInterpolation
  def to_s
    @value.to_s
  end
end