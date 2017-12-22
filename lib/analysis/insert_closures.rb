# insert_closures.rb - method insert_closures(ast) - pulls StoreClosure objects
# out of Lambdas and adds them as uncle nodes in AST

def insert_closures(ast)
  lambdas = select_class(ast, Lambda)
  lambdas.each do |l|
    l.content.closures.each do |c|
      add_uncle(l, c)
    end
  end
end
