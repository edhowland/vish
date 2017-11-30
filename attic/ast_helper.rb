# ast_helper.rb - methods to help pry AstTransform
require 'pp'

require_relative 'vish'
require_relative 'mini'
require_relative 'ast_transform'


def baddr(l,r)
  BinaryTreeFactory.subtree(BinaryAdd, Numeral.new(l), Numeral.new(r))
end


def style string
  m = Mini.new
  i = m.parse string
  a = AstTransform.new
  t = a.apply(i)
  return m,i,a,t
end
