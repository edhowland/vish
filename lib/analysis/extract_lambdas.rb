# extract_lambdas.rb - method extract_lambdas ast - returns detached Lambdas

def extract_lambdas(ast)
  lambdas = ast.select {|n| n.content.class == Lambda }
end