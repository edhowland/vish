# list_type.rb - class ListType < Terminal - holds a array
# Usage: arr=[1,2,3] - AST node of ListType is returned
# Internally, emits code to call :icall, :mkvector w/arguments

# TODO Rename me to VectorNode

class ListType < Terminal
def initialize
  @argc = 0
end
attr_accessor :argc
  def emit(bc, ctx)
  bc.codes << :pushl
  bc.codes << @argc
    bc.codes << :pushl
    bc.codes << :mkvector
    bc.codes << :icall
  end

  def inspect
    "#{self.class.name}: argc: #{@argc}"
  end
end