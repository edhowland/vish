# assign.rb - class  Assign < NonTerminal - The '=' in assignment

class Assign < NonTerminal
  def emit(bc, ctx)
    bc << :assign
  end
end
