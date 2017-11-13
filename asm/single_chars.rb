# single_chars.rb - class SingleChars - include in Parslet classes

class SingleChars < Parslet::Parser
    rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }
  rule(:nl) { str("\n") }
  rule(:comma) { str(',') }
  rule(:eq) { str('=') }
  rule(:octo) { str('#') }

  rule(:group) { str('  ') }
  rule(:lines) { nl >> nl }
end
