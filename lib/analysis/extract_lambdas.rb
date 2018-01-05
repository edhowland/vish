# extract_lambdas.rb - method extract_lambdas ast - returns detached Lambdas

def extract_lambdas(ast)
#  lambdas = ast.select {|n| n.content.class == Lambda }
lambdas = select_class(ast, Lambda)
  # get parents - returns list of tuples of parent, lambda
#  parentsof_lambdas = lambdas.map {|l| [l.parent, l] }

  # destructive actions below
#    lambdas.map!(&:remove_from_parent!)
lambda_names = lambdas.map {|l|  mknode(LambdaName.new(LambdaType.new(l.name, l.content.arglist.length))) }
ltuples = lambdas.zip(lambda_names)
ltuples.each {|l, n| l.replace_with(n) }
# create a hash so wecan remember the original lambda and its matching LambdaName
  ln = ltuples.map {|l, n| [l.name.to_sym, [l, n]] }.to_h

  # Add new LambdaName w/LambdaType to parent
#  parentsof_lambdas.each do|p, l|
#    ltype = LambdaType.new(p[1].name, p[1].content.arglist.length)
    # Now set the LambdaEntry.value to this LambdaType
#    p[1].first_child.content.value = ltype
#   p[0] << mknode(LambdaName.new(ltype))
#  end

#  lambdas
  ln
end


# append_lambdas AST, lambdas_h
# parses the ln hash from  extract_lambdas and reappends, just thelambda back
# onto the ast
def append_lambdas(ast, lambdas_h)
  lambdas_h.values.each {|l, n| ast << l }
end


# resolve_lambdas_locations
# After generation, returns the generated offset for each lambda
# to its LambdaName.LambdaType
def resolve_lambdas_locations(lambdas_h)
  lambdas_h.values.map {|l, n| [l.first_child.content, n.content] }.each {|l, n| n.value.target = l.offset }
end