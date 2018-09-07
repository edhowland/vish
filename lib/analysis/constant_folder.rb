# constant_folder.rb - class ConstantFolder - part of analysis in VishCompiler

class ConstantFolder
  include TreeUtils

  def run(ast)
    copy_tree(ast)
  end
end
