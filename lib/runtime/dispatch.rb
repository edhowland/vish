# dispatch.rb - class Dispatch - determins the internal method to call

module Dispatch
  def self.locate(meth, klasses=[Builtins])
    klasses.find {|k| k.respond_to? meth }
  end

  def self.delegate(meth, *args)
  klass = locate(meth)
  raise UnknownFunction.new(meth) if klass.nil?
    klass.send(meth, *args)
  end
end
