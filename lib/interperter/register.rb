# register.rb - class Register - storage for temporary values

# class Register - works like a CPU register
# Note the kind of reversed meaning of methods load, store
# These refer to the contents of the register wrt memory
class Register
  attr_accessor :value
  def load(value)
    @value = value
  end
  def store
    @value
  end
end
