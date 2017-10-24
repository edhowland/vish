# parse.rb - method parse(string) - returns AST

# TODO: Currently, the AST is just an Array

def parse(string)
  [Numeral.new(1), Numeral.new(34), BinaryAdd.new(), LValue.new('result'), Assign.new, Deref.new('result'), Final.new]
end
