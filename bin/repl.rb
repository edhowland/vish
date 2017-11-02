#!/usr/bin/env ruby
# REPL  without the L(oop)

require 'pp'

require_relative '../lib/vish'




ecode = 1
cli = HighLine.new
begin
#  print 'vish> '
 # string = gets.chomp
ctx = Context.new
loop do
string = cli.ask 'vish> '
  break  if string[0] == 'q' || string.chomp == 'exit' 
  ir  = VishParser.new.parse(string)
  ast =  AstTransform.new.apply ir

bc, ctx = emit_walker ast, ctx
  ci = CodeInterperter.new(bc, ctx)
  result = ci.run


end # of loop
  ecode = 0

rescue Parslet::ParseFailed => failure
  puts failure.parse_failure_cause.ascii_tree
rescue => err
  puts err.class.name
  puts err.message
end
