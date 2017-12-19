# extract_lambdas.rb - method extract_lambdas ast - returns detached Lambdas

def extract_lambdas(ast)
  lambdas = ast.select {|n| n.content.class == Lambda }
  # get parents
  parentsof_lambdas = lambdas.map {|l| [l.parent, l] }

  # destructive actions below
    lambdas.map!(&:remove_from_parent!)

  # Add new LambdaName w/LambdaType to parent
  parentsof_lambdas.each do|p|
    ltype = LambdaType.new(p[1].name, p[1].content.arglist.length)
    # Now set the LambdaEntry.value to this LambdaType
    p[1].first_child.content.value = ltype
   p[0] << mknode(LambdaName.new(ltype))
  end

  lambdas
end
