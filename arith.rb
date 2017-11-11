
require 'parslet'

class Arith < Parslet::Parser
  rule(:space) { match(/[\t ]/).repeat(1) }
  rule(:space?) { space.maybe }

  rule(:lparen)     { str('(') >> space? }
  rule(:rparen)     { str(')') >> space? }

  rule(:plus) { str('+') }
  rule(:star) { str('*') }

  rule(:integer) { match('[0-9]').repeat(1).as(:int) >> space? }
  rule(:term) { factor.as(:l) >> plus >> factor.as(:r)  |
       factor }

  rule(:factor) { integer.as(:l) >> star >> integer.as(:r) | 
      lparen >> term >> rparen |
  integer }

    root(:term)
end
