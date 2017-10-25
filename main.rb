#!/usr/bin/env ruby
# main.rb - main file for bytecode interpretation

require_relative 'viper'
require_relative 'interp'
require_relative 'load_source'
require_relative 'compile'


source = load_source(ARGF)
bc, ctx = compile(source)
# Now run our bytecode interperter with bc and ctx
#binding.pry
x_status = 0
begin
  interp(bc, ctx)
rescue OpcodeError => err
  $stderr.puts err.message
  exit(err.exit_code)
rescue ErrorState => err
  $stderr.puts err.message
  x_status = err.exit_code
  $stderr.puts 'bytecodes:'
  $stderr.puts bc.inspect
  $stderr.puts 'Context'
  $stderr.puts ctx.inspect
  rescue HaltState => state
    x_status = state.exit_code
end

exit(x_status)

