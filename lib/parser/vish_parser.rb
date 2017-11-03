# vish_parser.rb -  class VishParser <  < Parslet::Parser
# generates a parser from our grammar
# This grammar accepts strings: integer | integer + integer | function(expr [, expr)
# Usage: parser = VishParser.new; parser.parse('puts(1+2,3)') => Hash of intermediate AST
  require 'parslet' 

class VishParser < Parslet::Parser
  # empty string
  rule(:empty) { str('').as(:empty) }
  # single character rules
  rule(:newline) { str("\n") }
  rule(:semicolon) { str(';') }
  rule(:lparen)     { str('(') >> space? }
  rule(:rparen)     { str(')') >> space? }
    rule(:comma)      { str(',') >> space? }
  rule(:equals) { str('=') >> space? }
  rule(:colon) { str(':') }
  rule(:plus) { str('+') }
  rule(:minus) { str('-') }
  rule(:star) { str('*') }
  rule(:fslash) { str('/') }

  rule(:integer) { match('[0-9]').repeat(1).as(:int) >> space? }
  rule(:identifier) { match('[a-z]').repeat(1) }

  # This is Whitespace, not a single space
  rule(:space) { match(/[\t ]/).repeat(1) }
  rule(:space?) { space.maybe }

  rule(:oper)  { plus | minus | star | fslash }
  rule(:arith) { integer.as(:left) >> space? >> oper.as(:op) >> space? >> expr.as(:right) }
  rule(:assign) { identifier.as(:lvalue) >> equals.as(:eq) >> expr.as(:rvalue) }
  rule(:deref) { colon >> identifier.as(:deref) }

  # Function calls TODO: change to fn arg1 arg2 arg3 ... argn
  rule(:arglist) { expr >> (comma >> expr).repeat }
  rule(:funcall) { identifier.as(:funcall) >> lparen >> arglist.as(:arglist) >> rparen }

  rule(:expr) { funcall | arith | deref | integer }
  rule(:statement) { assign | expr | empty }
  rule(:delim) { newline | semicolon }
  rule(:statement_list) { statement >> (delim >> statement).repeat }
  rule(:program) { statement_list.as(:program) }

  # The mainroot of our tree
  root(:program)
end
