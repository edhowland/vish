# deref_list.rb - class DerefList < NonTerminal - holds a deref and its list

class DerefList < NonTerminal
  # subtree (Deref, Numeral|Symbol
  def self.subtree(deref, idx)
    top = mknode(self.new)
    top << node_unless(deref)
    top << node_unless(idx)

    top
  end

  def emit(bc, ctx)
    args = ctx.store_constant(2)  # Max 2 args
    bc.codes << :pushc
    bc.codes << args
    bc.codes << :pushl
    bc.codes << :ix
    bc.codes << :icall
  end

  def inspect
    "#{self.class.name}"
  end
end
