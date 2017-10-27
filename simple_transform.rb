# transform.rb - Class SimpleTransform

require 'parslet'

class SimpleTransform < Parslet::Transform
  rule(funcall: 'puts', arglist: sequence(:args)) {
      "puts(#{args.inspect})"
        }
end



def mktree
   {funcall: 'puts', arglist: [1,2,3]}
end