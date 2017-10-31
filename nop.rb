# nop.rb - class Nop < Terminal

class Nop < Terminal
  def emit(bc, ctx)
    bc.codes << :nop
  end
end
