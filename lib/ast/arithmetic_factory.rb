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
    when '%'
      BinaryModulo
    when '**'
      BinaryExponentiation
    when '=='
      BinaryEquality
    when '!='
      BinaryInequality
    when 'and'
      BooleanAnd
    when 'or'
      BooleanOr
    else
      raise "Unknown arithmetic operation requested: '#{op}'"
    end
    BinaryTreeFactory.subtree(klass, left, right)
  end
end