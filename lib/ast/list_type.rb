# list_type.rb - class ListType < Terminal - holds a array
# Usage: arr=[1,2,3] - AST node of ListType is returned
# Internally, emits code to call :icall, :list w/arguments


class ListType < Terminal
  def emit(bc, ctx)
  bc.codes << :pushl
  bc.codes << 0
    bc.codes << :pushl
    bc.codes << :list
    bc.codes << :icall
  end
end