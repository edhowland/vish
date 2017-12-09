# function_call.rb - class FunctionCall < Terminal
# Like Funcall, but for user defined functions. See: Function, FunctionEntry,
# FunctionExit.

class FunctionCall < Terminal
  def initialize value, argc=0
    @value = value.to_sym
    @argc = argc
    @target_p = ->() { 0 }
  end
  attr_accessor :argc, :target_p

  def emit(bc, ctx)
    cnt_off = ctx.store_constant(@argc)
    bc.codes << :pushc
    bc.codes << cnt_off
    bc.codes << :fcall
    bc.codes << @target_p
  end

  def inspect
    "FunctionCall name: #{@value} arg count: #{@argc}"
  end
end