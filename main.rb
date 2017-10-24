#!/usr/bin/env ruby
# main.rb - main file for bytecode interpretation

require_relative 'viper'
require_relative 'interp'
require_relative 'load_source'
require_relative 'compile'


source = load_source(ARGF)
bc, ctx = compile(source)




interp(bc, ctx)

puts 'The result is '
p ctx.stack.pop

