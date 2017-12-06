# lambda_entry.rb - class LambdaEntry < Terminal - emits code to consume args
# off stack in top frame

class LambdaEntry < Terminal
  def initialize arglist
    @arglist = arglist
  end
  attr_accessor :value

  # emit - emits assignments of n entries on stack.
  # Must use :swp after adding variable name pushed on stack
  # because :assign expects them in that order
  def emit(bc, ctx)
    ctx.vars[@value.to_sym] = bc.codes.length
    @arglist.reverse.each do |a|
      bc.codes << :pushl
      bc.codes << a.to_s.to_sym
      bc.codes << :swp
      bc.codes << :assign 
    end
  end
  def inspect
    self.class.name + ': ' + '[' + 
      @arglist.map(&:inspect).join(', ') + ']'
  end
end
