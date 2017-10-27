#!/usr/bin/env ruby
# REPL  without the L(oop)

require 'pp'
require_relative 'mini'

ecode = 1
begin
  print 'vish> '
  string = gets.chomp
  ast = Mini.new.parse(string)
  pp ast
  ecode = 0
rescue Parslet::ParseFailed => failure
  puts failure.parse_failure_cause.ascii_tree
rescue => err
  puts err.class.name
  puts err.message
end



exit(ecode)