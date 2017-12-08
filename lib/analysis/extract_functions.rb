# extract_functions.rb - method extract_functions (ast) - returns Function nodes
# Also sets @function_locations hash

def extract_functions(ast)
  functions = ast.select {|n| n.content.class == Function }

  # Create functio hash
  functions_h = functions.each_with_object({}) {|e, o| o[e.content.name.to_sym] = e }

    functions_h.values.map!(&:remove_from_parent!)
  functions_h
end
