# ast.rb - Placeholder for AST generation. Refactored from parse.rb

# TODO:The AST is hand crafted
# TODO : Remove this file from parse.rb. Replace with code from parslet parser generator.
require_relative 'mknode'

# A program is :

# expression1 ::= '35 + 2
# assign ::= result '=' expression1
# statement1 ::= assign
# program ::= statement1 ';' statement2 _ final

def program(*args)
  ProgramFactory.tree(*args)
end

def expression1
  BinaryTreeFactory.subtree(BinaryAdd, Numeral.new(35), Numeral.new(2))
end


def statement1
  s1 = mknode(Assign.new, 's1')
  s1 << mknode(LValue.new('result'))
  s1 << expression1
  s1
end

# s2 : result - dereferences the result variable
def statement2
  mknode(Deref.new('result'), 's2')
end


def final
  mknode(Final.new, 'final')
end


