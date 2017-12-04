# extract_lambdas.rb - method extract_lambdas ast - returns detached Lambdas

def extract_lambdas(ast)
  lambdas = ast.select {|n| n.content.class == Lambda }
  # get parents
  parentsof_lambdas = lambdas.map {|l| [l.parent, l] }

  # destructive actions below
    lambdas.map!(&:remove_from_parent!)
  # Add new StringLiteral of lambda's name to just extracted parent node
  parentsof_lambdas.each {|p| p[0] << mknode(StringLiteral.new(p[1].name)) }

  lambdas.each do |l|
    l.first_child.content.value = l.name
  end
  lambdas
end