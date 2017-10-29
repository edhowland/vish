#!/usr/bin/env ruby
# vishc.rb - compile vish program into bytecode
# The format of the bytecode is a JSON object containing bc, ctx
# The ByteCodes, Context after compile

require 'json'


require_relative 'vish'
require_relative 'mini'
require_relative 'ast_transform'
require_relative 'emit_walker'







source = ARGF.read

parser = Mini.new
tr = AstTransform.new

ir = parser.parse source

ast = tr.apply(ir)
bc, ctx = emit_walker(ast)

blob = {ctx: ctx.to_h, bc: bc.to_h }
puts blob.to_json

