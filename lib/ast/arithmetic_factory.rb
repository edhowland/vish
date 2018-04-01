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
    when '<'
      BinaryLess
    when '>'
      BinaryGreater
    when '<='
      BinaryLTE
    when '>='
      BinaryGTE
    when 'and'
      BooleanAnd
    when 'or'
      BooleanOr
    when '&&'
      LogicalAnd
    when '||'
      LogicalOr
    when '|'
      Pipe
    else
      raise "Unknown arithmetic operation requested: '#{op}'"
    end
    BinaryTreeFactory.subtree(klass, left, right)
  end
end