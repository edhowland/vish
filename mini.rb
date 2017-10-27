# mini.rb -  class Mini <  < Parslet::Parser
# generates a parser from our grammar

  require 'parslet' 

class Mini < Parslet::Parser
  # single character rules

  rule(:lparen)     { str('(') >> space? }
  rule(:rparen)     { str(')') >> space? }
    rule(:comma)      { str(',') >> space? }

  rule(:integer) { match('[0-9]').repeat(1).as(:int) >> space? }
  rule(:identifier) { match['a-z'].repeat(1) }

  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }

  rule(:oper) { match('[+]') >> space? }
  rule(:sum) { integer >> oper >> expr }
  rule(:expr) { sum | integer }

  root(:expr)
end
