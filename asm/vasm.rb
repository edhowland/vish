#!/usr/bin/env ruby
# vasm.rb - assembles .vasm files into .vsc bytecode files

require_relative '../lib/vish'

require_relative 'vasm_requires'


require_relative '../common/store_codes'

require_relative 'vasm_grammar'
require_relative 'utilities'
require_relative 'vasm_transform'
require_relative 'codes_and_labels'






fin, fout = ARGV

parser = VasmGrammar.new


input = File.read(fin)
exit_status = 1
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
  raise UnresolvedTargetsError.new(targets) if targets.any?(&:unresolved?)
  bc.codes = codes
  out = File.open(fout, 'w')
  store_codes(bc, ctx, out)

  # check for any unfreiended labels
  if labels.any?(&:unconnected?)
    puts "Hmmm. We assembled your code into #{fout}, but we noticed some unconnected labels. Here they are"
    labels.select(&:unconnected?).each {|l| puts l.inspect }
  end
  exit_status = 0
rescue Parslet::ParseFailed => failure
  puts failure.parse_failure_cause.ascii_tree  
rescue => err
  puts err.message
  # normally comment this out
#  puts err.backtrace
end


exit(exit_status)
