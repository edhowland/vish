#!/usr/bin/env ruby
# REPL  without the L(oop)

require_relative 'mini'

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