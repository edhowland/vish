# lambda_entry.rb - class LambdaEntry < Terminal - emits code to consume args
# off stack in top frame

class LambdaEntry < Terminal
  def initialize arglist
    @arglist = arglist
    @offset = 0
  end
  attr_reader :offset
  attr_accessor :value

  # emit - emits assignments of n entries on stack.
  # Must use :swp after adding variable name pushed on stack
  # because :assign expects them in that order
  # 
  # Sets the offset for later exfiltration in analyze of compiler
  # which adds to matching LambdaName.LambdaType.target
  def emit(bc, ctx)
@offset = bc.codes.length
#binding.pry
    jmp_t = BulletinBoard.get(@value.name) || JumpTarget.new(@value.name)
jmp_t.target = bc.codes.length
# The BB.put is idempotent
BulletinBoard.put(jmp_t)

    # TODO: REMOVEME
#    bc.codes << :vars_push unless @arglist.empty?
    # Now assign any parameters to the frame's vars
    @arglist.reverse.each do |a|
      bc.codes << :pushl
      bc.codes << a.to_s.to_sym
      bc.codes << :swp
      bc.codes << :set  #:assign 
    end
  end

  def inspect
    self.class.name + ': value: ' + @value.inspect + ' arglist: [' + 
      @arglist.map(&:inspect).join(', ') + ']'
  end
end
