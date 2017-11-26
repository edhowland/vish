# exit.rb - class Exit < Terminal - emits :halt
# is generated in AST with 'exit' keyword

class Exit < Terminal
  # emit an interrupt to go to the installed exit handler, if any
  def emit(bc, ctx)
    bc.codes << :int
    bc.codes << :_exit
  end
end