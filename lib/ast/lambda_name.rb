# lambda_name.rb - class LambdaName  < Terminal - holds LambdaType

class LambdaName < Terminal

  # get the LambdaType from the ctx.constants, push it, clone it, save the
  # frame_id into frame_ptr
  # TODO: MUST change this to just be the actual Lambda object, not the LambdaType
  # The reason is this  is only known to Builtins.mklambda
  def emit(bc, ctx)
    bc.codes << :pushl
    bc.codes << @value.name
    bc.codes << :pushl
    bc.codes << @value.arity
    bc.codes << :pushl
    jmp_t = BulletinBoard.get(@value.name) || JumpTarget.new(@value.name)
    bc.codes << jmp_t # @value.target
    bc.codes << :pushl
    bc.codes << 3
    bc.codes << :pushl
    bc.codes << :mklambda
    bc.codes << :icall
    bc.codes << :savefp
    bc.codes << :alloc
  end

  def inspect
    "LambdaName: value: #{@value.inspect}"
  end
end