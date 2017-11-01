#!/usr/bin/env ruby
# REPL  without the L(oop)
# Uses the Mini Parslet generated parser
# TODO:  Make this work with AstTransform class, then emit the bc stuff, then run

require 'pp'

require_relative '../vish'
require_relative '../mini'
require_relative '../ast_transform'
require_relative '../code_interperter'




ecode = 1
cli = HighLine.new
begin
#  print 'vish> '
 # string = gets.chomp
loop do
string = cli.ask 'vish> '
  break  if string[0] == 'q' || string.chomp == 'exit' 
  ir  = Mini.new.parse(string)
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
