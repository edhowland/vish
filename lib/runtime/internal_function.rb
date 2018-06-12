# internal_function.rb - class InternalFunction < ambdaType - wraps Builtins,
# any FFI user supplied functions
# This lambda differs from normal by not actually calling binding.dup

class InternalFunction < LambdaType
  def binding_dup
    self[:binding]
  end
  def inspect
    "#{self.class.name} #{self[:name]}"
  end
end