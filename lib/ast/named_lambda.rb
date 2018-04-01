# named_lambda.rb - class NamedLambda < Lambda
# A NamedLambda is a Lambda witha name.
# This:
# defn foo(a) { :a + 1 }
# Turns into
# foo=->(a) { :a + 1 }
# Additionally, the compiler stores a the name of the function for 
# foo(4)


class NamedLambda < Lambda
  attr_accessor :name

  def self.subtree(parmlist, body, fname)
    top = super(parmlist, body)
    top.content.name = fname.to_s.to_sym

    top
  end

  def inspect
  super + "name: #{@name}"
    #"#{self.class.name}: name: #{@name}"
  end
end
