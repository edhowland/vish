# binary_gte.rb - class BinaryGTE < NonTerminal 3 >= 2 is true


class BinaryGTE < NonTerminal
  def emit(bc, ctx)
    bc.codes << :gte
  end
end