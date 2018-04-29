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
read() | parse() | _emit() | _halt() | _attach() | _jump()
EOC

c = VishCompiler.new source
bc, ctx = c.run
ci = CodeInterpreter.new c.bc, c.ctx
print '>> '
result = ci.run
p result

