#!/usr/bin/env ruby
# vishc.rb - compile vish program into bytecode
# The format of the bytecode is a Ruby Marshall serialized object after
# The ByteCodes, Context after they been compiled.
# Usage: ./vishc file.vsh file.vshc


require_relative '../lib/vish'
require_relative 'store_codes'


fin, fout = ARGV
fin = File.open(fin, 'r')
source = fin.read
fin.close
parser = VishParser.new
tr = AstTransform.new

begin
ir = parser.parse source

ast = tr.apply(ir)
bc, ctx = emit_walker(ast)

# now write it out to file.vshc
io = File.open(fout, 'w')
store_codes(bc, ctx, io)
rescue Parslet::ParseFailed => failure
  puts failure.parse_failure_cause.ascii_tree
rescue => err
  puts err.class.name
  puts err.message
  end
  