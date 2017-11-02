# arrithmetic_factory.rb - class ArithmeticFactory -
# constructs some BinaryAdd[Sub,Mult,Div]

class ArithmeticFactory
  def self.subtree(op, left, right)
    klass = case op
    when '+'
      BinaryAdd
    when '-'
      BinarySub
    when '*'
      BinaryMult
    when '/'
      BinaryDiv
    else
      raise "Unknown arithmetic operation requested: '#{op}'"
    end
    BinaryTreeFactory.subtree(klass, left, right)
  end
end