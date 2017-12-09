# function_entry.rb - class FunctionEntry < Terminal
class FunctionEntry < Terminal
  def initialize arglist
        @arglist = arglist
        @target = 0
  end
  attr_reader :target
  attr_accessor :value

  def emit(bc, ctx)
    @target = bc.codes.length
       @arglist.reverse.each do |a|
      bc.codes << :pushl
      bc.codes << a.to_s.to_sym
      bc.codes << :swp
      bc.codes << :assign 
    end 
  end

  # return lambda closure around the value of @target
  def target_p
    ->() { @target }
  end

  def inspect
    "FunctionEntry  arglist: #{@arglist.inspect} target: #{@target}"
  end
end