# null_node.rb - class NullNode < Terminal - a null pair type: ()

class NullNode < Terminal
  def emit(bc, ctx)
  bc.codes << :pushl
    bc << 0
    bc.codes << :pushl
        bc.codes << :mknull
    bc.codes << :icall
  end

  def inspect
    "#{self.class.name}"
  end
end
