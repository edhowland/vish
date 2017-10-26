# parse.rb - method parse(string) - returns AST
require_relative 'ast'


def parse(string)
  ast = program(statement1, statement2)
  ast

#  [Numeral.new(1), Numeral.new(34), BinaryAdd.new(), LValue.new('result'), Assign.new, Deref.new('result'), Final.new]
end
