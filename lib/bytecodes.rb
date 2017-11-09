# bytecodes.rb - class ByteCodes - collection of individual bytecodes
# attr: pc : The current increment - Can be set for looping/branching, .etc
#  :codes : The list of bytecodes
# methods: :next : returns next element from codes


class ByteCodes
  def initialize
    @codes = []
    @pc = 0
  end
  attr_accessor :pc, :codes

  def <<(value)
    @codes << value
  end

  def next
    code = @codes[@pc]
    @pc += 1
    code
  end
  def length
    @codes.length
  end
  def to_h
    {codes: @codes, pc: @pc }
  end
  
  # for debugging
  # peek: seek out the  next code that will be run
  def peek
    @codes[@pc]
  end

  # inspect: outputs string form ByteCodes instance
  def inspect
    "pc: #{@pc} codes: #{@codes.inspect}"
  end
end
