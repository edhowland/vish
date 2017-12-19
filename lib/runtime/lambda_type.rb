# lambda_type.rb - class LambdaType - holds data regarding lambda :location, 
# arity, etc

class LambdaType
  def initialize name, arity=0
    @name = name
    @arity = arity
    @target = 0
  end
  attr_reader :name, :arity
  attr_accessor :target
  def inspect
    "LambdaType: name: #{name}, arity: #{@arity}, target: #{@target}"
  end
end
