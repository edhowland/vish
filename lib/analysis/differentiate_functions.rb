# buffer differentiate_functions.rb - method differentiate_functions(ast, fn_h)
# finds all the Funcall nodes, and possibly replaces them with FunctionCalls
# only if they exit in functions hash

def differentiate_functions(ast, functions)
  funcalls = ast.select {|n| n.content.class == Funcall }
  replacements = funcalls.select {|n| functions.has_key?(n.content.name) }
  replacements.each {|n| n.content = FunctionCall.new(n.content.name) }
end
