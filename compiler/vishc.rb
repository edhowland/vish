#!/usr/bin/env ruby
# vishc.rb - compile vish program into bytecode
# The format of the bytecode is a Ruby Marshall serialized object after
# The ByteCodes, Context after they been compiled.
# Usage: ./vishc file.vsh file.vshc

require 'optparse'

require_relative '../lib/vish'
require_relative '../common/store_codes'

options = {
  check: false
}

opt = OptionParser.new do |o|
o.banner = 'Vish compiler'
o.separator ''
  o.on('-c', '--check', 'Check syntax') do
    options[:check] = true
  end
  o.separator ''
  o.on('-h', '--help', 'Display this help') do |op|
    puts o
    exit(0)
  end
  o.on('-v', '--version', 'Report version of Vish language') do
    puts "Vish version: #{Vish::VERSION}"
    exit(0)
  end
end
opt.parse!

fin, fout = ARGV
fin = File.open(fin, 'r')
source = fin.read
fin.close

if options[:check]
  compiler = VishCompiler.new source
  compiler.parse
  compiler.transform
  compiler.analyze
  puts 'Syntax OK'
  exit(0)
end

exit_status = 1
begin
  compiler = VishCompiler.new source
  compiler.run

  # now write it out to file.vshc
io = File.open(fout, 'w')
  store_codes(compiler.bc, compiler.ctx, io)
  exit_status = 0
rescue Parslet::ParseFailed => failure
  puts failure.parse_failure_cause.ascii_tree
rescue => err
  puts err.class.name
  puts err.message
  end


exit(exit_status)
