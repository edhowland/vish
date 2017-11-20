# ast.rb - Placeholder for AST generation. Refactored from parse.rb



# TODO:The AST is hand crafted

$node_name = 0
def mknode(value, name=sprintf('%04d', $node_name))
  $node_name += 1
  Tree::TreeNode.new(name, value)
end

# A program is :
# program ::= statement; statement _ final
def program(*args)
  pgm = mknode(Start.new, 'program')
  args.each {|a| pgm << a }
  # get the final thing
  pgm << final
  pgm
end

# s1 : result=42
def statement1
#  s1 = mknode(Assign.new, 's1') <<
#    mknode(LValue.new('result'))
#  s1 << mknode(Numeral.new(42))

  s1 = mknode(Assign.new, 's1')
  s1 << mknode(LValue.new('result'))
  s1 << mknode(Numeral.new(42))
  s1
end

# s2 : result - dereferences the result variable
def statement2
  mknode(Deref.new('result'), 's2')
end


def final
  mknode(Final.new, 'final')
end


