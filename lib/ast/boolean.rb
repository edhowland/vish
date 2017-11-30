# boolean.rb - class Boolean < Terminal

class Boolean < Terminal
  def initialize string_slice
  @h = @h || Hash.new { raise RuntimeError.new('Unknown boolean literal. Only true or false') }
  @h['true'] = true
  @h['false'] = false
    super @h[string_slice.to_s.strip]
  end
  def emit(bc, ctx)
    bc << :pushc
    bc << ctx.store_constant(@value)
  end
end