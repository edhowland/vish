# deref_block.rb - class DerefBlock < Deref - emits :bcall

class DerefBlock < Deref

  # emits a :bcall which pulls name off sstack, derefs that, then goes there
  def emit(bc, ctx)
    super
    bc.codes << :bcall
  end

  def inspect
    "#{self.class.name}: value: #{@value}"
  end
end