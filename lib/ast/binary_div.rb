# binary_div.rb - classBinaryDiv < NonTerminal


class BinaryDiv < NonTerminal
  def emit(bc, ctx)
    bc << :div
  end
end
 
