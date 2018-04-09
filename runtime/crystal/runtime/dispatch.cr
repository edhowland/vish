# dispatch.rb - class Dispatch - determins the internal method to call

module Dispatch
  @@klasses = [Builtins]
  def self.klasses
    @@klasses
  end
  def self.<<(klass)
    @@klasses << klass
  end
  def self.locate(meth, klasses=@@klasses)
    klasses.find {|k| k.respond_to? meth }
  end

  def self.delegate(meth, *args)
  klass = locate(meth)
  raise UnknownFunction.new(meth) if klass.nil?
    klass.send(meth, *args)
  end
end