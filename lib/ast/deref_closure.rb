# deref_closure.rb - class DerefClosure < Terminal - Dereferences a value
# stored in a closure on the heap with @value as id


class DerefClosure < Terminal
  def emit(bc, ctx)
    bc.codes << :pushcl
    bc.codes << @value
  end

  def inspect
    "#{self.class.name}: value: #{@value}"
  end
end