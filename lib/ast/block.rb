# block.rb - class Block < NonTerminal - holds onto list of statements
# TODO: improve this below comment
# For now, emit performs a nop

class Block < NonTerminal
  def initialize value='inline'
    @value = value
    @from = ''
  end
  attr_accessor :value, :from
  def self.subtree(list)
    top = mknode(self.new)
    list.each {|n| top << node_unless(n) }
    top
  end
  def emit(bc, ctx)
    # nop, ... for now
  end
  def inspect
    "#{self.class.name} value: #{@value}"
  end
end
