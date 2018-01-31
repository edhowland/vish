# undefined_variable.rb - class UndefinedVariable < VishRuntimeError
# does what it says on the tin

class UndefinedVariable < VishRuntimeError
  def initialize var_name
    super "#{var_name} is undefined"
  end
end
