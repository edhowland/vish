#!/usr/bin/env ruby
# main.rb - main file for bytecode interpretation

require_relative 'viper'
require_relative 'interp'


ctx = Context.new
bc = ByteCodes.new




# Hand walk the AST
# for this expression/statement
# result = 1 + 34
num_1 = Numeral.new(1)
num_34 = Numeral.new(34)
num_1.emit(bc, ctx)
num_34.emit(bc, ctx)
adder = BinaryAdd.new
adder.emit(bc, ctx)

interp(bc, ctx)

puts 'The result is '
p ctx.stack.pop

