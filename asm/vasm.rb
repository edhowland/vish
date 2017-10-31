#!/usr/bin/env ruby
# vasm.rb - assembles .vasm files into .vshc bytecode files

require_relative '../compiler/store_codes'

require_relative 'vasm_grammar'
require_relative 'utilities'
require_relative 'vasm_transform'
require_relative '../context'
require_relative '../bytecode'






fin, fout = ARGV

parser = VasmGrammar.new


input = File.read(fin)
begin
  ir =  parser.parse(input)
  tr = VasmTransform.new
  im = tr.apply(ir)
  ctx = Context.new

  ctx.constants = im[:ctx][:constants]
  ctx.vars = im[:ctx][:vars][:vlist].to_h
  bc = ByteCodes.new;
  bc.codes = im[:codes].map {|x| x[:statement] }.flatten
  out = File.open(fout, 'w')
  store_codes(bc, ctx, out)
rescue Parslet::ParseFailed => failure
  puts failure.parse_failure_cause.ascii_tree  
end
