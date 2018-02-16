# lambda_type.rb - class LambdaType < Type - holds data regarding lambda :location, 
# arity, etc

# module LambdaFunction < Type 
# Used for typeof? operator
module LambdaFunction
  include Type
end


class LambdaType
  include Type
  def initialize name, arity=0
    @name = name
    @name.extend(LambdaFunction)
    @arity = arity
    @target = 0
    @binding = nil
  end
  attr_reader :name, :arity
  attr_accessor :target, :binding
  def inspect
    "LambdaType: name: #{name}, arity: #{@arity}, target: #{@target} binding: #{@binding}"
  end
end
