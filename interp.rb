#!/usr/bin/env ruby
# interp.rb - Main file for bytecode interperter

require_relative 'viper'
ctx = Context.new
bc = ByteCodes.new
pcodes = opcodes


# This next line might happen when walking the AST
#bc.codes = [:pushc, ctx.store_constant(1)]
num_1 = Numeral.new(1)
num_34 = Numeral.new(34)
num_1.emit(bc, ctx)
num_34.emit(bc, ctx)

2.times do
  code = bc.next
  pcodes[code].call(bc, ctx)
end

# dump remaining stack
p ctx.stack

