# vasm_grammar.rb - class VasmGrammar < Parslet::Parser


require 'parslet'
require_relative 'single_chars'      # Import single character rules

class VasmGrammar < Parslet::Parser
  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }
  rule(:nl) { str("\n") }
  rule(:comma) { str(',') }
  rule(:eq) { str('=') }
  rule(:octo) { str('#') }
  rule(:blahblah) { match(/[.a-zA-z0-9\ ]/).repeat(1) } 
  rule(:identifier) { match('[a-z]').repeat(1) }
  rule(:rvalue) { match(/[a-zA-Z0-9]/).repeat(1) }

  rule(:comment) { octo >> blahblah >> nl }

  # numbers
  rule(:integer) { match('[0-9]').repeat(1) }

  # context:
  rule(:constants) { str('constants:') >> (space >> integer.as(:int) >> (comma >> integer.as(:int)).repeat).maybe.as(:clist) >> nl }

# vars:
  rule(:assign) { str('  ') >> identifier.as(:ident) >> eq >> rvalue.as(:rvalue) >> nl }
  rule(:vars) { str('vars:') >> nl >> assign.repeat.as(:vlist) }
  rule(:context) { str('context:') >> nl >> constants.as(:constants) >> vars.as(:vars) }
  # codes:
  rule(:opcode) { match(/[a-z]/).repeat(1) }
  rule(:operand) { match(/[a-zA-Z0-9]/).repeat(1) }
  rule(:arg) { space >> operand }

  rule(:statement) { opcode >> arg.maybe >> nl }
  rule(:sourceline) { comment | statement }
  rule(:codes) { str('codes:') >> nl >> sourceline.repeat(1) }
rule(:program) { comment >> context.as(:ctx) >> codes.as(:codes) }

  # The root of our grammar for Vish assembly instructions
  root(:program)
end
