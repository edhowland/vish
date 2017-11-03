# program_factory.rb - class ProgramFactory
# TODo remove the following note:
# Used in both ast.rb and ast_transform.rb
# The latter is for transforming the parse output from Nini class

class ProgramFactory
  def self.tree(*args)
      pgm = mknode(Start.new, 'program')
  args.each do |a|
    # Add this node before every statement. Start with a clean/clear stack
    pgm << mknode(ClearStack.new)
    if !a.instance_of? Tree::TreeNode
      a = mknode(a)
    end
    pgm << a 
  end
  pgm << mknode(Final.new, 'final')
  pgm
  end
end
