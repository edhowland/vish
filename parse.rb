# parse.rb - method parse(string) - returns AST

# TODO:The AST is hand crafted

$node_name = 0
def mknode(value, name=sprintf('%04d', $node_name))
  $node_name += 1
  Tree::TreeNode.new(name, value)
end

# A program is :
# program ::= statement; statement _ final
def program(*args)
  pgm = mknode(Assign.new, 'program')
  args.each {|a| pgm << a }
  # get the final thing
  pgm << final
  pgm
end

def statement1
  mknode(LValue.new('result'), 's1')
end

def statement2
  mknode(Numeral.new(42), 's2')
end


def final
  mknode(Final.new, 'final')
end
def parse(string)
  ast = program(statement1, statement2)
  ast

#  [Numeral.new(1), Numeral.new(34), BinaryAdd.new(), LValue.new('result'), Assign.new, Deref.new('result'), Final.new]
end
