# mini.rb -  class Mini <  < Parslet::Parser
# generates a parser from our grammar

  require 'parslet' 

class Mini < Parslet::Parser
  rule(:integer) { match('[0-9]').repeat(1) >> space? }
  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }
  rule(:oper) { match('\+') >> space? }
  rule(:sum) { integer >> oper >> expr }
  rule(:expr) { sum | integer }

  root(:expr)
end
