# curry_function.rb - class CurryFunction < LambdaType - curried function.

class CurryFunction < LambdaType
  def initialize parent
    parent.each do |k, v|
      self[k] = v
    end
  end
end


