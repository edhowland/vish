# transform.rb - Class SimpleTransform

require 'parslet'
require_relative 'vish'

class SimpleTransform < Parslet::Transform
  rule(funcall: simple(:funcall), arglist: sequence(:args)) {
      # "puts(#{args.inspect})"
      Funcall.new(funcall, args)
        }
end

# for testing the above example rule:funcall
def mktree
   {funcall: 'echo', arglist: [1,2,3]}
end

def mks
  SimpleTransform.new
end