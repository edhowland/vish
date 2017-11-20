# string_expression.rb - class StringExpression < NonTerminal - used for :{expr}
# will emit :str after the children nodes have had a go at emmitting their stuff

class StringExpression < NonTerminal
  def emit(bc, ctx)
    bc.codes << :str
  end
end