# keyword.rb - class Keyword < NonTerminal - handlers for various keywords
# 'break' => Break, ... else UnknownKeyword. 
# UnknownKeyword emits a :err opcode

class UnknownKeyword < Terminal
  def emit(bc, ctx)
    bc.codes << :err
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
    klass = class_for(string)
    mknode(klass.new)
  end
end
