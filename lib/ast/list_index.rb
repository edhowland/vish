# lib/ast/list_index.rb - class ListIndex < Terminal - Indexes a list element
# a=[0,1,2,3]; :m[2] => 2

class ListIndex < Terminal
def initialize deref, index
  @deref = deref
  @index = index
end
attr_accessor :deref, :index

  def self.leaf(deref, index)
    mknode(self.new(deref, index))
  end

  # emit - Order of parameters to :icall of :ix builtin
  # @deref.emit is called first. Value of varaible is placed on top of stack
  # @index stored herein ... to top of stack
  # number of parameters to builtin: 2
  # :ix - Builtin.ix(array, index)
  # :icall
  def emit(bc, ctx)
  @deref.emit(bc, ctx)
  
    con = ctx.store_constant(@index.to_i)
    bc.codes << :pushc
    bc.codes << con
    bc.codes << :pushl
    bc.codes << 2
    bc.codes << :pushl
    bc.codes << :ix
    bc.codes << :icall
  end

  def inspect
    "#{self.class.name}: deref: #{@deref.inspect}, index: #{@index.inspect}"
  end
end
