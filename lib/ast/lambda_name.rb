# lambda_name.rb - class LambdaName  < Terminal - holds LambdaType

class LambdaName < Terminal
  def emit(bc, ctx)
    bc.codes << :pushc
    bc.codes << ctx.store_constant(@value)
  end

  def inspect
    "LambdaName: value: #{@value.inspect}"
  end
end