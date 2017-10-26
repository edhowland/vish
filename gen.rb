# gen.rb - generates a parser from our grammar

  require 'parslet' 

class Mini < Parslet::Parser
  rule(:integer) { match('[0-9]').repeat(1) >> space? }
  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }
  rule(:oper) { match('\+') >> space? }
  rule(:sum) { integer >> oper >> integer }
  # root(:oper) #
  root(:sum)
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
rescue => err
  puts err.class.name
  puts err.message
end



exit(ecode)