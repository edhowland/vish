# vish_parser.rb -  class VishParser <  < Parslet::Parser
# generates a parser from our grammar
# This grammar accepts strings: integer | integer + integer | function(expr [, expr)
# Usage: parser = VishParser.new; parser.parse('puts(1+2,3)') => Hash of intermediate AST
# email address for parslet authors:
# ruby.parslet@librelist.com

  require 'parslet' 

class VishParser < Parslet::Parser
  # empty string
  rule(:empty) { str('').as(:empty) }
  # single character rules
  rule(:newline) { str("\n") }
  rule(:semicolon) { str(';') }
  rule(:octo) { str('#') }
  rule(:lparen)     { str('(') >> space? }
  rule(:rparen)     { str(')') >> space? }
    rule(:comma)      { str(',') >> space? }
  rule(:equals) { str('=') >> space? }
  rule(:colon) { str(':') }
  rule(:plus) { str('+') }
  rule(:minus) { str('-') }
  rule(:star) { str('*') }
  rule(:fslash) { str('/') }
  # Logical ops
  rule(:bang) { str('!') }
    rule(:equal_equal) { str('==') }
  rule(:bang_equal) { str('!=') }


  rule(:integer) { match('[0-9]').repeat(1).as(:int) >> space? }
  rule(:identifier) { match(/[a-zA-Z0-9_]/).repeat(1) } # .repeat(1)

  # This is Whitespace, not a single space; does not include newlines. See that rule
  rule(:space) { match(/[\t ]/).repeat(1) }
  rule(:space?) { space.maybe }


  # matches anything upto a newline
  rule(:notnl) { match(/[^\n]/).repeat }
  rule(:comment) { octo >> notnl >> newline.maybe }

  # operators and precedence
#  rule(:infix_oper) { infix_expression(expr, [star, 2, :left], [plus, 1, :right]) }

  rule(:add_op) { plus | minus }
  rule(:mult_op) { star | fslash }
  rule(:additive) { multiplicative.as(:left) >> add_op.as(:op) >> multiplicative.as(:right) |
    multiplicative }
  rule(:multiplicative) { lvalue.as(:left) >> mult_op.as(:op) >> integer.as(:right) |  # maybe: expr
    lvalue }
  rule(:oper)  { star | fslash | plus | minus | equal_equal | bang_equal }
  rule(:lvalue) { integer | deref }

  rule(:negation) { bang.as(:op) >> space? >> expr.as(:negation) }
  rule(:arith) { lvalue.as(:left) >> space? >> oper.as(:op) >> space? >> expr.as(:right) }
  rule(:assign) { identifier.as(:lvalue) >> equals.as(:eq) >> expr.as(:rvalue) }
  rule(:deref) { colon >> identifier.as(:deref) }

  # Function calls TODO: change to fn arg1 arg2 arg3 ... argn
  rule(:arglist) { expr >> (comma >> expr).repeat }
  rule(:funcall) { identifier.as(:funcall) >> lparen >> arglist.as(:arglist) >> rparen }

  # Expressions, assignments, etc.
  rule(:expr) { funcall | negation | additive  | deref | integer } # arith

  # A statement is either an assignment, an expression or the empty match, possibly preceeded by whitespace
  rule(:statement) { space? >> (assign | expr | empty) }
  rule(:delim) { newline | semicolon | comment }
  rule(:statement_list) { statement >> (delim >> statement).repeat }

  # The top node :program is made up of many statements
  rule(:program) { statement_list.as(:program) }

  # The mainroot of our tree
  root(:program)
end
