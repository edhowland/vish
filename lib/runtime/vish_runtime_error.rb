# vish_runtime_error.rb - class VishRuntimeError < RuntimeError - base for Vish
# all such runtime errors

class VishRuntimeError < RuntimeError
  #
end

class VishTypeError < VishRuntimeError
  #
end

class VishArgumentError < VishRuntimeError
  def initialize arity=0, got=0
    super "Wrong number of arguments: expected: #{arity}, got #{got}" 
  end
end
