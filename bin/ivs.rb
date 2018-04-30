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
defn repl() {
  read() | parse() | _emit() |  _call() | print()
}
loop { prints(">> "); repl() }
EOC

c = VishCompiler.new source
bc, ctx = c.run
ci = CodeInterpreter.new c.bc, c.ctx
result = ci.run

