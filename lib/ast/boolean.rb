# boolean.rb - class Boolean < Terminal

class Boolean < Terminal
  def initialize string_slice
  @h = @h || Hash.new { raise RuntimeError.new('Unknown boolean literal. Only true or false') }
  @h['true'] = true
  @h['false'] = false
    super @h[string_slice]
  end
  def emit(bc, ctx)
    bc.codes << @value
  end
end