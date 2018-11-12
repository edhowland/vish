# tre_utils.rb - Module TreeUtils : like copy_tree

# TreeUtils - Used in optimizers within VishCompiler
module TreeUtils
  include ListProc

  ##
  
def contains? tree, sym, result=false
  if null?(tree)
    result
  elsif list?(car(tree)) && caar(tree) == sym
    contains?(cdr(tree), sym, true)
  else
    contains?(cdr(tree), sym, result)
  end
end
def filter_list_for(lst, **nf)
  if null?(lst)
    NullType.new
    elsif list?(car(lst)) && nf[caar(lst)]
      filter_list_for(cdr(lst), **nf)
  else
      cons(car(lst), filter_list_for(cdr(lst), **nf))
  end
end

def filter_tree_for(tree, **nf)
  map_inner_tree(tree) do |node|
    if list?(node) && nf.keys.reduce(false) {|i, j| i || contains?(node, j) }
      filter_list_for(node, **nf)
    else
      node
    end
  end
end
  ##
  # map_tree_with tree, nf: optional keywords
  # Returns tree after replacing requested node types  with output of passed
  # lambdas
  def map_tree_with(tree, **nf)
    map_inner_tree(tree) do |node|
      if list?(node) && nf[car(node)]
        nf[car(node)].call(node)
      else
        node
      end
    end
  end

  ##
  # visit_tree AST, **visiters
  # Walks the AST, possibly calling Procs passed in visiters keyword hash
  #
  # Example: Given: t=list(:foo, 1, list(:bar, 2))
  # visit_tree(t, foo: ->(st) { puts "in foo: #{cadr(st).inspect}"}, bar:->(st) { puts "in bar: #{cadr(st).inspect}"})
  #  in foo: 1
  #  in bar: 2
  def visit_tree(ast, **nf)
    if null?(ast)
      NullType.new
    elsif pair?(car(ast))
      visit_tree(car(ast), **nf)
      visit_tree(cdr(ast), **nf)
    else
      if nf[car(ast)]
        nf[car(ast)].call(ast)
      end
    visit_tree(cdr(ast), **nf)
    end
  end

  def copy_tree(ast, &blk)
    if !null?(ast) && pair?(ast) && atom?(car(ast))
      yield car(ast) if block_given?
    end

    if null?(ast)
      NullType.new
    elsif pair?(car(ast))
      cons(copy_tree(car(ast), &blk), copy_tree(cdr(ast), &blk))
    else
      cons(car(ast), copy_tree(cdr(ast), &blk))
    end
  end

  def map_tree(ast, &blk)
    if !null?(ast) && pair?(ast) && atom?(car(ast))
      yield car(ast) if block_given?
    end

    if null?(ast)
      NullType.new
    elsif pair?(car(ast))
      cons(map_tree(car(ast), &blk), map_tree(cdr(ast), &blk))
    else
      cons(blk.call(car(ast)), map_tree(cdr(ast), &blk))
    end
  end

  def map_inner_tree(ast, &blk)
    if !null?(ast) && pair?(ast) && atom?(car(ast))
      yield car(ast) if block_given?
    end

    if null?(ast)
      NullType.new
    elsif pair?(car(ast))
      cons(map_inner_tree(blk.call(car(ast)), &blk), map_inner_tree(cdr(ast), &blk))
    else
      cons(car(ast), map_inner_tree(cdr(ast), &blk))
    end
  end

# get the last item in list
def last_element(sexp)
  if null?(sexp)
    sexp
  elsif null?(cdr(sexp))
    car(sexp)
  else
    last_element(cdr(sexp))
  end
end
end
  