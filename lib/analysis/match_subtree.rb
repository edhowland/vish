# match_subtree.rb - method match_subtree  ast, tuple - returns list of matching
# nodes

# mkmonad :method, class :  returns curried lambda to find node whose
# content.class == klass
def mkmonad(method, klass)
  ->(m, k, e) { e && e.send(m) {|f| f.content.instance_of?(k) } }.curry[method][klass]
end

# mkmatchers path : path of classes is converted to matcher monads
def mkmatchers(tuple)
  tuple.map {|k| mkmonad(:find, k) }
end

def match_subtree(ast, tuple)
  nodes = ast
  tuple.each do |k|
    nodes = nodes.select {|e| e.content.instance_of?(k) }
  end
  nodes
end
