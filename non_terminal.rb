# non_terminal.rb - class NonTerminal - Base class for operators and stuff

class NonTerminal
  def emit(bc, ctx)
    raise 'Invalid call to NonTerminal.emit'
  end
end
