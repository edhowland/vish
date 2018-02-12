# lambda_name.rb - class LambdaName  < Terminal - holds LambdaType

class LambdaName < Terminal

  #Use Builtin.mklambda(name, arity, target)
  #  This is all just setup for the runtime call to this method which returns
  # the actual lambda
  # We also create a JumpTarget and store it in the BulletinBoard and emit it here.
  # Then we save the appro frame on the call stack into the LambdaType
  # Then we allocate space for it on heap
  # Finnaly, the heap pointer is returned
  def emit(bc, ctx)
    bc.codes << :pushl
    bc.codes << @value.name
    bc.codes << :pushl
    bc.codes << @value.arity
    bc.codes << :pushl
    jmp_t = JumpTarget.new(@value.name)
    BulletinBoard.put(jmp_t)    
    bc.codes << jmp_t
    bc.codes << :pushl
    bc.codes << 3
    bc.codes << :pushl
    bc.codes << :mklambda
    bc.codes << :icall
    bc.codes << :savefp
    bc.codes << :alloc
  end

  def inspect
    "#{self.class.name}: value: #{@value.inspect}"
  end
end