# copy_tree.rb - copies input tree, with possible changed subtree via passed
#block

def copy_tree(ast)
  if null?(ast)
    NullType.new
  else
    cons(car(ast), copy_tree(cdr(ast)))
  end
end