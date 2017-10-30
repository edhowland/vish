#!/usr/bin/env ruby
# vishc.rb - compile vish program into bytecode
# The format of the bytecode is a Ruby Marshall serialized object after
# The ByteCodes, Context after they been compiled.



require_relative '../vish'
require_relative '../mini'
require_relative '../ast_transform'
require_relative '../emit_walker'
require_relative 'store_codes'


source = ARGF.read

parser = Mini.new
tr = AstTransform.new

ir = parser.parse source

ast = tr.apply(ir)
bc, ctx = emit_walker(ast)

# now write it out to file.vshc
io = File.open('file.vshc', 'w')
store_codes(bc, ctx, io)
