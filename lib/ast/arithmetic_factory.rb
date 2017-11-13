# arrithmetic_factory.rb - class ArithmeticFactory -
# constructs some BinaryAdd[Sub,Mult,Div]

class ArithmeticFactory
  def self.subtree(op, left, right)
    klass = case op.to_s.strip
    when '+'
      BinaryAdd
    when '-'
      BinarySub
    when '*'
      BinaryMult
    when '/'
      BinaryDiv
    when '=='
      BinaryEquality
    when '!='
      BinaryInequality
    else
      raise "Unknown arithmetic operation requested: '#{op}'"
    end
    BinaryTreeFactory.subtree(klass, left, right)
  end
end