# resolve_lambda_locations.rb - method resolve_lambda_locations(bytecodes)
# puts the :lcall jump targets in places where LambdaName emitted code

def resolve_lambda_locations(bc)
  bc.codes.each_with_index do |e, i|
    if e.kind_of?(JumpTarget)
      bc.codes[i] = e.target
    end
  end
end
