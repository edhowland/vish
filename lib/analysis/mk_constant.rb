# mk_constant.rb - Class MkConstant - container for Parselet::Slice

class MkConstant
  def initialize slice
    @slice = slice
  end
  attr_reader :slice
  def integer
    @slice.to_s.to_i
  end
end

