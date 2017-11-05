#!/usr/bin/env ruby
# vasm.rb - assembles .vasm files into .vshc bytecode files

require_relative '../lib/vish'

require_relative 'vasm_requires'


require_relative '../compiler/store_codes'

require_relative 'vasm_grammar'
require_relative 'utilities'
require_relative 'vasm_transform'
require_relative 'codes_and_labels'






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
  bc = ByteCodes.new

# restore the int-iness of numeric opcodes
#  codes = im[:codes].map {|c| has_numeric_operand?(c[0]) ? [c[0], c[1].to_i] : c }.flatten
  codes, labels, targets = codes_and_labels(im[:codes])
  codes = resolve_targets(codes, labels, targets)

  bc.codes = codes
  out = File.open(fout, 'w')
  store_codes(bc, ctx, out)
rescue Parslet::ParseFailed => failure
  puts failure.parse_failure_cause.ascii_tree  
end
