# mini.rb -  class Mini <  < Parslet::Parser
# generates a parser from our grammar
# This grammar accepts strings: integer | integer + integer | function(expr [, expr)
# Usage: parser = Mini.new; parser.parse('puts(1+2,3)') => Hash of intermediate AST
  require 'parslet' 

class VishParser < Parslet::Parser
  # empty string
  rule(:empty) { str('').as(:empty) }
  # single character rules
  rule(:lparen)     { str('(') >> space? }
  rule(:rparen)     { str(')') >> space? }
    rule(:comma)      { str(',') >> space? }
  rule(:equals) { str('=') >> space? }

  rule(:integer) { match('[0-9]').repeat(1).as(:int) >> space? }
  rule(:identifier) { match('[a-z]').repeat(1) }

  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }

  rule(:oper) { match('[+]') >> space? }
  rule(:sum) { integer.as(:left) >> oper.as(:op) >> expr.as(:right) }
  rule(:assign) { identifier.as(:lvalue) >> equals.as(:eq) >> expr.as(:rvalue) }
  rule(:arglist) { expr >> (comma >> expr).repeat }
  rule(:funcall) { identifier.as(:funcall) >> lparen >> arglist.as(:arglist) >> rparen }

  rule(:expr) { funcall | sum | integer }
  rule(:statement) { assign | expr | empty }
  rule(:program) { statement.as(:program) }

  # The mainroot of our tree
  root(:program)
end
