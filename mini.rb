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

# Mini.new.parse("132432")  # => "132432"@0

# REPL  without the L(oop)
ecode = 1
begin
  print 'vish> '
  string = gets.chomp
  Mini.new.parse(string)
  puts 'done'
  ecode = 0
rescue Parslet::ParseFailed => failure
  puts failure.parse_failure_cause.ascii_tree
rescue => err
  puts err.class.name
  puts err.message
end



exit(ecode)