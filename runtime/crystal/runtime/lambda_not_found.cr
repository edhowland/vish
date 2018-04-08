# lambda_not_found.rb - class LambdaNotFound < RuntimeError
# raised if there is no actual Lambda body to jump to

class LambdaNotFound < VishRuntimeError
  def initialize name
    super "Lambda not found: #{name}"
  end
end