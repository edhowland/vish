#!/usr/bin/env ruby
# vdis.rb - Disassembles .vshc files into .vasm source

require_relative '../runtime/load_codes'
require_relative '../opcodes'  # for has_operand? code

def constants ctx
  result = ''
  unless ctx.constants.empty?
    result = " #{ctx.constants.join(',')}"
  end
  result
end

fin, fout = ARGV

bc, ctx = load_codes(File.open(fin, 'r'))


out = File.open(fout, 'w')
out.puts "# #{ARGV[0]} disassembly into #{ARGV[1]}"


# write out the ctx : Context struct , sans the stack
out.puts "context:"
out.puts "constants:" + constants(ctx)
out.puts "vars:"
ctx.vars.each_pair {|k, v| out.puts "  #{k}=#{v}" }
out.puts "codes:"
enumr = bc.codes.each
begin
  loop do
  operand = ''
    code = enumr.next
    if has_operand? code
      operand = enumr.next
      operand = " #{operand}"
    end
    out.puts "#{code}#{operand}"
  end
rescue StopIteration
  # nop
end
out.close
