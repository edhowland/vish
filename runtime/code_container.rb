# code_container.rb - class CodeContainer - Used to store ByteCodes, Context
# in serialized format


class CodeContainer
  def initialize bc, ctx
    @ctx = ctx
    @bc = bc
  end
  attr_reader :bc, :ctx
end
