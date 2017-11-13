# binary_exponentiation.rb - class BinaryExponentiation < NonTerminal - emits ':exp

class BinaryExponentiation < NonTerminal
  def emit bc, ctx
    bc.codes << :exp
  end
end