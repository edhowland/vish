# stack_not_empty.rb - class  StackNotEmpty < ErrorState - raised if 
#stack not empty after processing all the bytecodes

class StackNotEmpty < ErrorState
  def initialize
    super "#{self.class.name}: Stack should be empty after the last bytecode has been executed"
  end
end
