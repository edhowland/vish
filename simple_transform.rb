# transform.rb - Class SimpleTransform

require 'parslet'
require_relative 'vish'

class SimpleTransform < Parslet::Transform
  rule(funcall: 'puts', arglist: sequence(:args)) {
      # "puts(#{args.inspect})"
      Funcall.new('puts', args)
        }
end

# for testing the above example rule:funcall
def mktree
   {funcall: 'puts', arglist: [1,2,3]}
end

def mks
  SimpleTransform.new
end