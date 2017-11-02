#!/usr/bin/env ruby
# REPL  without the L(oop)

require 'pp'

require_relative '../lib/vish'




ecode = 1
cli = HighLine.new
begin
#  print 'vish> '
 # string = gets.chomp
loop do
string = cli.ask 'vish> '
  break  if string[0] == 'q' || string.chomp == 'exit' 
  ir  = VishParser.new.parse(string)
#   pp ir
  ast =  AstTransform.new.apply ir
#   ast.each {|n| p n.content }
bc, ctx = emit_walker ast
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
