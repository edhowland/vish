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
  rule(:plus) { str('+') >> space? }
  rule(:minus) { str('-') >> space? }
  rule(:star) { str('*') >> space? }
  rule(:fslash) { str('/') >> space? }
  rule(:percent) { str('%') >> space? }
  rule(:star_star) { str("\*\*") >> space? }
  # Logical ops
  rule(:bang) { str('!') }
  rule(:l_and) { str('and') >> space? }
  rule(:l_or) { str('or') >> space? }
    rule(:equal_equal) { str('==') >> space? }
  rule(:bang_equal) { str('!=') >> space? }


  rule(:integer) { match('[0-9]').repeat(1).as(:int) >> space? }
  rule(:bool_t) { str('true') >> space? }
  rule(:bool_f) { str('false') >> space? }
  rule(:boolean) { (bool_t | bool_f).as(:boolean) }

  # An identifier is an ident_head (_a-zA-Z) followed by 0 or more of ident_tail, which ident_head + digits
  rule(:ident_head) { match(/[_a-zA-Z]/) }
  rule(:ident_tail) { match(/[a-zA-Z0-9_]/).repeat(1) }
  rule(:identifier) { ident_head >> ident_tail.maybe }
  # This is Whitespace, not a single space; does not include newlines. See that rule
  rule(:space) { match(/[\t ]/).repeat(1) }
  rule(:space?) { space.maybe }


  # matches anything upto a newline
  rule(:notnl) { match(/[^\n]/).repeat }
  rule(:comment) { octo >> notnl >> newline.maybe }

  # operators and precedence
  # Note: Only do binary operators here. The meaning of infix!
  rule(:infix_oper) { infix_expression(group,
    [star_star, 5, :left],
    [star, 4, :left], [fslash, 4, :left], [percent, 4, :left],
    [plus, 3, :right], [minus, 3, :right],
    [equal_equal, 2, :left], [bang_equal, 2, :left],
    [l_and, 1, :left], [l_or, 1, :left]) }

  # parenthesis:
  rule(:group) { lparen >> space? >> infix_oper >> space? >> rparen | lvalue }

  rule(:lvalue) { integer | boolean | deref }

  rule(:negation) { bang.as(:op) >> space? >> expr.as(:negation) }

  rule(:assign) { identifier.as(:lvalue) >> equals.as(:eq) >> expr.as(:rvalue) }
  rule(:deref) { colon >> identifier.as(:deref) >> space? }

  # Function calls TODO: change to fn arg1 arg2 arg3 ... argn
  rule(:arglist) { expr >> (comma >> expr).repeat }
  rule(:funcall) { identifier.as(:funcall) >> lparen >> arglist.as(:arglist) >> rparen }


  # Expressions, assignments, etc.
  rule(:expr) { funcall | negation | infix_oper | deref | integer }

  # A statement is either an assignment, an expression or the empty match, possibly preceeded by whitespace
  rule(:statement) { space? >> (assign | expr | empty) }
  rule(:delim) { newline | semicolon | comment }
  rule(:statement_list) { statement >> (delim >> statement).repeat }

  # The top node :program is made up of many statements
  rule(:program) { statement_list.as(:program) }

  # The mainroot of our tree
  root(:program)
end
