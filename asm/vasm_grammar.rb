# vasm_grammar.rb - class VasmGrammar < Parslet::Parser


require 'parslet'

class VasmGrammar < Parslet::Parser
  rule(:nl) { str("\n") }
  rule(:octo) { str('#') }
  rule(:blahblah) { match(/[a-zA-z0-9\ ]/).repeat(1) } 
  rule(:comment) { octo >> blahblah >> nl }
  root(:comment)
end
