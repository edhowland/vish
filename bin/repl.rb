#!/usr/bin/env ruby
# repl.rb - linked to ./bin/vish
# REPL  without the L(oop)

require 'highline'
require_relative '../lib/vish'

def log(*message)
  $stderr.puts(*message)
  File.open('vish.log', 'w') do |f|
    f.puts(*message)
  end
end

# err(RuntimeError) - logs error message and logs first 10 lines of stackstarace
def err(exc)
  log exc.class.name
  log exc.message
  exc.backtrace[0..10].each {|t| log t }
end

ecode = 1
cli = HighLine.new
begin
  compiler = VishCompiler.new
interperter = CodeInterperter.new(nil, nil)

loop do
string = cli.ask 'vish> '
  break  if string[0] == 'q' # || string.chomp == 'Exit'  
  ncmp = VishCompiler.new string
  ncmp.parse; ncmp.transform; ncmp.analyze
  ncmp.blocks = compiler.blocks + ncmp.blocks
  ncmp.lambdas = compiler.lambdas + ncmp.lambdas
  ncmp.ctx = compiler.ctx.merge(ncmp.ctx)
  compiler = ncmp
  compiler.generate

  interpreter = CodeInterperter.new(compiler.bc, compiler.ctx)
  p interpreter.run
  break if interpreter.last_exception.kind_of?(ExitState)
end
  ecode = 0
rescue CompileError => err
  log err.message
rescue Parslet::ParseFailed => failure
  log failure.parse_failure_cause.ascii_tree
rescue => exc
  err(exc)
end
exit(ecode)
