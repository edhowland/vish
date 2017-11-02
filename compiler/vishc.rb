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
parser = Mini.new
tr = AstTransform.new

ir = parser.parse source

ast = tr.apply(ir)
bc, ctx = emit_walker(ast)

# now write it out to file.vshc
io = File.open(fout, 'w')
store_codes(bc, ctx, io)
