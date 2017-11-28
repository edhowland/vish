# keyword.rb - class Keyword < NonTerminal - handlers for various keywords
# 'break' => Break, ... else UnknownKeyword. 
# UnknownKeyword emits a :err opcode

class UnknownKeyword < Terminal
  # TODO: MUST change this to become new runtime error interrupt handler
  # :int, :_error
  def emit(bc, ctx)
    bc.codes << :int
    bc .codes << :_default
  end
end

class Keyword < NonTerminal
  def self.class_for string
    case string
    when 'break'
      Break
    when 'exit'
      Exit
    else
      UnknownKeyword
    end
  end

  def self.subtree(string)
    return string if string.instance_of?(Tree::TreeNode)
    klass = class_for(string)
    mknode(klass.new)
  end
end
