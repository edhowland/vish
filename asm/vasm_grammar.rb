# vasm_grammar.rb - class VasmGrammar < Parslet::Parser


require 'parslet'

class VasmGrammar < Parslet::Parser
  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }
  rule(:nl) { str("\n") }
  rule(:octo) { str('#') }
  rule(:blahblah) { match(/[.a-zA-z0-9\ ]/).repeat(1) } 
  rule(:comment) { octo >> blahblah >> nl }

  rule(:opcode) { match(/[a-z]/).repeat(1) }
  rule(:operand) { match(/[a-zA-Z0-9]/).repeat(1) }
  rule(:arg) { space >> operand }

  rule(:statement) { opcode >> arg.maybe >> nl }
  rule(:sourceline) { comment | statement }
  rule(:term) { sourceline.repeat(1) }

  # The root of our grammar for Vish assembly instructions
  root(:term)
end
