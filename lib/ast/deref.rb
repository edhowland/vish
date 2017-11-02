# deref.rb - class Deref < Terminal - given a key name push its value

class Deref < Terminal
  def emit(bc, ctx)
    bc << :pushv
    bc << @value.to_sym
  end
end
