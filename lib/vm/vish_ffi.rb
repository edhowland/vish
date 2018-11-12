# vish_ffi.rb - class VishFFI - Container for FFI methods, primitives

class VishFFI
  # include interpreter methods
  def initialize vm
    @vm = vm
  end
  attr_reader :vm
end