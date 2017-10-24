#!/usr/bin/env ruby
# interp.rb - Main file for bytecode interperter

require_relative 'viper'
ctx = Context.new
bc = ByteCodes.new
pcodes = opcodes


# This next line might happen when walking the AST
num_1 = Numeral.new(1)
num_34 = Numeral.new(34)
num_1.emit(bc, ctx)
num_34.emit(bc, ctx)
adder = BinaryAdd.new
adder.emit(bc, ctx)

# main interperter run loop:
loop do
  code = bc.next
  break if code.nil?
  pcodes[code].call(bc, ctx)
end

# dump remaining stack
puts 'after interperter run'
p ctx.stack

