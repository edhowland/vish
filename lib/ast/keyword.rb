# keyword.rb - class Keyword < NonTerminal - handlers for various keywords
# 'break' => Break, ... else UnknownKeyword. 


class UnknownKeyword < Terminal

  def emit(bc, ctx)
    raise CompileError.new("Unknown keyword encountered #{@value}")
  end
end

class Keyword < NonTerminal
  def self.class_for string
    case string.to_s.strip
    when 'break'
      Break
    when 'exit'
      Exit
    when 'Null'
      NullNode
    else
    binding.pry
      UnknownKeyword
    end
  end

  def self.subtree(string)
    return string if string.instance_of?(Tree::TreeNode)
    klass = class_for(string)
    mknode(klass.new(string.to_s))
  end
end
