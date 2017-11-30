#!/usr/bin/env ruby
# vdis.rb - Disassembles .vshc files into .vasm source

require_relative '../common/load_codes'
require_relative '../lib/vish'  # for has_operand? code
require_relative 'vasm_requires'
# Our own Target class: UnknownTarget
require_relative 'unknown_target'
require_relative 'dis_requires'

def constants ctx
  result = ''
  unless ctx.constants.empty?
    result = " #{ctx.constants.join(',')}"
  end
  result
end


def space_operand operand
  if operand.nil?
    ''
  else
    " #{operand.value}"
  end
end

# main code
fin, fout = ARGV

bc, ctx = load_codes(File.open(fin, 'r'))


out = File.open(fout, 'w')
# Output the comment that we disassembeled your bytecodes into vasm source.
out.puts "# #{ARGV[0]} disassembly into #{ARGV[1]}"


# write out the ctx : Context struct , sans the stack
out.puts "context:"
out.puts "constants:" + constants(ctx)
out.puts "vars:"
ctx.vars.each_pair {|k, v| out.puts "  #{k}=#{v}" }
out.puts "codes:"

# get array of opcode, tuples
tuples = codes_to_tuples bc.codes
fmt = tuples.map {|c, o| "#{c.to_s}#{space_operand(o)}" }
out.puts fmt.join("\n")

out.close
