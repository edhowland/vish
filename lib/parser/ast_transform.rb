# ast_transform.rb - class AstTransform <  Parslet::Transform

#require_relative 'vish'

class AstTransform < Parslet::Transform
  # handle the empty input case
  rule(empty: simple(:empty)) { Nop.new }
  rule(int: simple(:int)) { Numeral.new(int) }
  # arithmetic expressions
  rule(left: simple(:lvalue), op: simple(:op), right: simple(:rvalue)) { ArithmeticFactory.subtree(op, lvalue, rvalue) }
  rule(lvalue: simple(:lvalue), eq: simple(:eq), rvalue: simple(:rvalue)) { BinaryTreeFactory.subtree(Assign, LValue.new(lvalue), rvalue) }

  # dereference a variable
  rule(deref: simple(:deref)) { mknode(Deref.new(deref)) }

  rule(program: simple(:program)) { ProgramFactory.tree(program) }
  rule(program: sequence(:program)) { ProgramFactory.tree(*program) }
end

