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
  rule(:lbrace) { str('{') }
  rule(:rbrace) { str('}') }
    rule(:comma)      { str(',') >> space? }
  rule(:equals) { str('=') >> space? }
  rule(:colon) { str(':') }
  rule(:plus) { str('+') >> space? }
  rule(:minus) { str('-') >> space? }
  rule(:star) { str('*') >> space? }
  rule(:fslash) { str('/') >> space? }
  rule(:bslash) { str('\\') }
  rule(:percent) { str('%') >> space? }
  rule(:star_star) { str("\*\*") >> space? }
  # some punctuation
  rule(:dquote) { str('"') }
  rule(:squote) { str("'") }
  # Logical ops
  rule(:bang) { str('!') }
  rule(:l_and) { str('and') >> space? }
  rule(:l_or) { str('or') >> space? }
    rule(:equal_equal) { str('==') >> space? }
  rule(:bang_equal) { str('!=') >> space? }
  # Control flow
  rule(:ampersand) { str('&') }
  rule(:pipe) { str('|') }
  rule(:logical_and) { ampersand >> ampersand >> space? }
  rule(:logical_or) { pipe >> pipe >> space? }

  rule(:integer) { match('[0-9]').repeat(1).as(:int) >> space? }
  rule(:bool_t) { str('true') >> space? }
  rule(:bool_f) { str('false') >> space? }
  rule(:boolean) { (bool_t | bool_f).as(:boolean) }


  # string interpolation stuff
  # See: Notes.md
  rule(:colon_lbrace) { colon >> lbrace }
  rule(:deref_expr) { colon_lbrace >> expr >> rbrace }

  # escape sequences
  rule(:esc_newline) { bslash >> str('n') }
  rule(:esc_tab) { bslash >> str('t') }

  rule(:esc_bslash) { bslash >> bslash }
  rule(:esc_dquote) { bslash >> dquote }
  rule(:esc_squote) { bslash >> squote }
  # TODO: make room for hex digits: \x00fe, ... posibly unicodes, etc
  rule(:escape_seq) { esc_newline | esc_tab | esc_bslash | esc_dquote | esc_squote }


  # interpolated string is any amount of string_atoms, deref_expr and escape_seq 
  # surrounded by dquotes
  #
    # a string atom is a string_quark and  or a deref_expr(:{ expr }) , or a an escape_seq(\n, ...)
    rule(:string_quark) { dquote.absent? >> any }
    rule(:string_atom) { escape_seq.as(:escape_seq) | deref_expr.as(:string_expr) | string_quark.as(:strtok) }

  # A stringcule  (string molecule)  is  any sequence of string atoms
    rule(:stringcule) { string_atom.repeat }
    rule(:string_interpolation) { dquote >> stringcule.as(:string_interpolation) >> dquote }

  # from parslet/examples/string_parser.rb. But changed to single quotes "'this is a string'"
    rule(:sq_string) do
    str("'") >> 
    (
      (str('\\') >> any) |
      (str("'").absent? >> any)
    ).repeat.as(:sq_string) >> 
    str("'")
  end
  rule(:dq_string) { string_interpolation >> space? }

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

  rule(:lvalue) { integer | boolean | dq_string | sq_string | deref }

  rule(:negation) { bang.as(:op) >> space? >> expr.as(:negation) }

  rule(:assign) { identifier.as(:lvalue) >> equals.as(:eq) >> expr.as(:rvalue) }
  rule(:deref) { colon >> identifier.as(:deref) >> space? }
  # This syntax: %block will cause emitter to push CodeContainer, then :exec
  rule(:deref_block) { percent >> identifier.as(:deref_block) >> space? }

  # Function calls TODO: change to fn arg1 arg2 arg3 ... argn
  rule(:arg_atoms) { expr >> (comma >> expr).repeat }
  rule(:arglist) { arg_atoms |  space?   }
  rule(:funcall) { identifier.as(:funcall) >> lparen >> arglist.as(:arglist) >> rparen }


  # Expressions, assignments, etc.
  rule(:expr) { block | funcall | negation | infix_oper | deref | deref_block | integer }

  # A statement is either an assignment, an expression, deref(... _block) or the empty match, possibly preceeded by whitespace
  rule(:statement) { space? >> (block | assign | expr | empty) }
  rule(:delim) { newline | semicolon | comment }
  rule(:conditional_or_statement) { (conditional_and | conditional_or) | block | statement }
  rule(:statement_list) { conditional_or_statement >> (delim >> conditional_or_statement).repeat }
  rule(:block) { lbrace >> statement_list.as(:block) >> rbrace }

  # conditional flow
  rule(:conditional_and) { statement.as(:and_left) >> logical_and >> conditional_or_statement.as(:and_right) } # was: statement
  rule(:conditional_or) { statement.as(:or_left) >> logical_or >> conditional_or_statement.as(:or_right) }

  # The top node :program is made up of many statements
  rule(:program) { statement_list.as(:program) }

  # The mainroot of our tree
  root(:program)
end

