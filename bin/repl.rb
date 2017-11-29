#!/usr/bin/env ruby
# repl.rb - linked to ./bin/vish
# REPL  without the L(oop)

require 'pp'

require_relative '../lib/vish'

def log(*message)
  $stderr.puts(*message)
  File.open('vish.log', 'w') do |f|
    f.puts(*message)
  end
end

def err(exc)
  log exc.class.name
  log exc.message
  exc.backtrace[0..10].each {|t| log t }
end

$exit_called = false
ecode = 1
cli = HighLine.new
begin
  compiler = VishCompiler.new
#binding.pry
interperter = CodeInterperter.new(nil, nil)
nbc = ByteCodes.new
nctx = Context.new
nbc.codes = [:error, 'Exit state reached',:halt]
interperter.handlers[:_exit] = [nbc, nctx]

loop do
string = cli.ask 'vish> '
  break  if string[0] == 'q' || string.chomp == 'Exit'  || $exit_called

  compiler.run string
# TODO: This next line is bogus. We should just append new compile stuff (AST)
  interperter.bc = compiler.bc
  interperter.ctx = compiler.ctx
  result = interperter.run
end
  ecode = 0
rescue ErrorState => err
  log err.message
rescue Parslet::ParseFailed => failure
  log failure.parse_failure_cause.ascii_tree
rescue => exc
  err(exc)
end
