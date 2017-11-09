# vasm_grammar.rb - class VasmGrammar < Parslet::Parser

require 'parslet'
require_relative 'single_chars'      # Import single character rules

class VasmGrammar < Parslet::Parser
# BUG: Make this work like in VishGrammar to be only whitespace excluding nl
  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }

  # single characters
  rule(:nl) { str("\n") }
  rule(:comma) { str(',') }
  rule(:eq) { str('=') }
  rule(:octo) { str('#') }
  rule(:notnl) { match(/[^\n]/).repeat }
  rule(:colon) { str(':') }
  rule(:identifier) { match(/[a-zA-Z0-9_]/).repeat(1) } # .repeat(1)

#  rule(:identifier) { match('[a-z]').repeat(1) }
  rule(:label) { colon >> identifier }
  rule(:rvalue) { match(/[a-zA-Z0-9]/).repeat(1) }

  rule(:comment) { octo >> notnl >> nl.maybe }

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
  rule(:operand) { match(/[a-zA-Z0-9]/).repeat(1).as(:operand) }
  rule(:arg) { space >> (operand | label.as(:target)) }

  rule(:statement1) { (label.as(:label) >> str(' ')).maybe >> opcode.as(:opcode) >> nl }
  rule(:statement2) {(label.as(:label) >> str(' ')).maybe >>  opcode.as(:opcode) >> arg >> nl }
  rule(:sourceline) { statement1 | statement2 }
  rule(:codes) { str('codes:') >> nl >> sourceline.repeat(1) }
rule(:program) { comment >> context.as(:ctx) >> codes.as(:codes) }

  # The root of our grammar for Vish assembly instructions
  root(:program)
end
