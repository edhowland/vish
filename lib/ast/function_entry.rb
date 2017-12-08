# function_entry.rb - class FunctionEntry < Terminal
class FunctionEntry < Terminal
  def initialize arglist
        @arglist = arglist
  end
  attr_accessor :value

  def emit(bc, ctx)
       @arglist.reverse.each do |a|
      bc.codes << :pushl
      bc.codes << a.to_s.to_sym
      bc.codes << :swp
      bc.codes << :assign 
    end 
  end
end