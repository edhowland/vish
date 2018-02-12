# memoize_functions.rb - method memoize_functions(ast, functions)
# Finds NamedLambdas and stores the name in functions hash

def memoize_functions(ast, functions)
  nls = select_class(ast, NamedLambda)
  nls.each do |nl|
    functions[nl.content.name.to_sym] = nl
  end
end
