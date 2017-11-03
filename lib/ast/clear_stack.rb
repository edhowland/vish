# clear_stack.rb - class ClearStack < Terminal - clears the stack at start of
# every new statement


class ClearStack < Terminal
  def emit(bc, ctx)
    bc << :cls
  end
end