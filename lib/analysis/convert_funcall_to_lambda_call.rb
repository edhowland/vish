# buffer convert_funcall_to_lambda_call.rb - method convert_funcall_to_lambda_call(ast, lambdas)

# convert_funcall_to_lambda_call(ast, lambdas=[])
# Finds Funcall nodes and replaces them with Lambda calls with same semantics
def convert_funcall_to_lambda_call(ast, functions={})
  funcalls = select_class(ast, Funcall)
  funcalls.each do |f|
    x =  functions[f.content.name.to_sym]
    if !x.nil?
      saved_argc = f.content.argc
      f.content = LambdaCall.new(f.content.name)
      f.content.argc = saved_argc
    end
  end
end
