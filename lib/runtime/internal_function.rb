# internal_function.rb - class InternalFunction < NambdaType - wraps Builtins,
# any FFI user supplied functions
# This lambda differs from normal by not actually calling binding.dup

class InternalFunction < NambdaType
  def inspect
    self.class.name
  end
end