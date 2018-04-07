# interpreter_methods.rb - module InterpreterMethods - expose
# CodeInterpreter stuff to runtime.
# E.g. binding()

module InterpreterMethods
  @@interpreter = nil
  def self.add_interpreter interpreter
    @@interpreter = interpreter
  end
  def self.binding()
    @@interpreter.frames.last.ctx.vars
  end
  ## binding?(object) - true if object is some binding
  def self.binding?(object)
    object.instance_of?(BindingType)
  end
end