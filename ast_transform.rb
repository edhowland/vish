# ast_transform.rb - class AstTransform <  Parslet::Transform
# TODO: remove the following note:
# This class is a spike for implementing a transform from
# the output of Mini.new.parse into a Rubytree tree of Terminals and NonTerminals

require_relative 'vish'

class AstTransform < Parslet::Transform
  rule(int: simple(:int)) { Numeral.new(int) }
end