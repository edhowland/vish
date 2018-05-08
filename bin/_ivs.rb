#!/usr/bin/env ruby
# ivs - Interactive Vish REPL
require_relative '../lib/vish'

module ParserLib
  def self.parse(string)
    c = VishCompiler.new string
    c.parse
    c.transform
    c.ast
  end
end

Dispatch << ParserLib


source =<<-EOC
  loop {
    prints('vish>')
    read() | parse() | _emit() | _icall _call: | print()
  }
EOC
source = File.read('std/lib.vs') + "\n" + source

c = VishCompiler.new source
bc, ctx = c.run
ci = CodeInterpreter.new c.bc, c.ctx
begin
  result = ci.run
rescue => err
  $stderr.puts  err.message
end

