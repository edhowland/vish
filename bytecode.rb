#!/usr/bin/env ruby
# bytecode.rb - class ByteCode - collection of individual bytecodes
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
end

