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
  # ffi_ruby - enumerate Builtin/required Ruby FFI methods
  def self.ffi_ruby
    @@klasses.map {|k| k.methods(false) }.flatten
  end

  # check if already contains this klass
  def self.contains?(klass)
    @@klasses.member? klass
  end
end
