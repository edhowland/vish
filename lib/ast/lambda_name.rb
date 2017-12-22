# lambda_name.rb - class LambdaName  < Terminal - holds LambdaType

class LambdaName < Terminal
  # get the LambdaType from the ctx.constants, push it, clone it, save the
  # frame_id into frame_ptr
  def emit(bc, ctx)
    bc.codes << :pushc
    bc.codes << ctx.store_constant(@value)
    bc.codes << :clone
    bc.codes << :savefp
  end

  def inspect
    "LambdaName: value: #{@value.inspect}"
  end
end