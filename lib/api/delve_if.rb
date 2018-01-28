# delve_if.rb - method delve_if object, method, *args. 
# sends method w/args to either object or if Tree::TreeNode.content

def delve_if(obj, meth, *args)
  if obj.kind_of? Tree::TreeNode
    obj.content.send(meth, *args)
    
  else
    obj.send(meth, *args)
  end
end