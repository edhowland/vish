# binary_sub.rb - classBinarySub < NonTerminal - emits a :sub 

class BinarySub < NonTerminal
  def emit(bc, ctx)
    bc << :sub
  end
end

