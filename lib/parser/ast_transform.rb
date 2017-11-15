# ast_transform.rb - class AstTransform <  Parslet::Transform

#require_relative 'vish'

class AstTransform < Parslet::Transform
  # debugging

  # handle the empty input case
  rule(empty: simple(:empty)) { :ignore }    # Nop.new 

  rule(int: simple(:int)) { Numeral.new(int) }
  rule(boolean: simple(:boolean)) { Boolean.new(boolean) }
  # logical operations

  # arithmetic expressions
  rule(l: simple(:lvalue), o: simple(:op), r: simple(:rvalue)) { ArithmeticFactory.subtree(op, lvalue, rvalue) }
  rule(lvalue: simple(:lvalue), eq: simple(:eq), rvalue: simple(:rvalue)) { BinaryTreeFactory.subtree(Assign, LValue.new(lvalue), rvalue) }
  rule(op: simple(:op), negation: simple(:negation)) { UnaryTreeFactory.subtree(UnaryNegation, negation) }

  # dereference a variable
  rule(deref: simple(:deref)) { mknode(Deref.new(deref)) }

  rule(program: simple(:program)) { ProgramFactory.tree(program) }
  rule(program: sequence(:program)) { ProgramFactory.tree(*program) }
end

