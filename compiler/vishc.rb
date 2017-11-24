#!/usr/bin/env ruby
# vishc.rb - compile vish program into bytecode
# The format of the bytecode is a Ruby Marshall serialized object after
# The ByteCodes, Context after they been compiled.
# Usage: ./vishc file.vsh file.vshc

require_relative '../lib/vish'
require_relative '../common/store_codes'


fin, fout = ARGV
fin = File.open(fin, 'r')
source = fin.read
fin.close

begin
  compiler = VishCompiler.new source
  compiler.run

# now write it out to file.vshc
io = File.open(fout, 'w')
store_codes(compiler.bc, compiler.ctx, io)
rescue Parslet::ParseFailed => failure
  puts failure.parse_failure_cause.ascii_tree
rescue => err
  puts err.class.name
  puts err.message
  end
