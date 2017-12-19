# program_factory.rb - class ProgramFactory

class ProgramFactory
  def self.tree(*args)
      pgm = mknode(Start.new, 'program')
  args.reject {|a| a.class == Ignore }.each do |a|
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
