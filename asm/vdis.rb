#!/usr/bin/env ruby
# vdis.rb - Disassembles .vshc files into .vasm source





require_relative '../runtime/load_codes'



fin, fout = ARGV

bc, ctx = load_codes(File.open(fin, 'r'))


out = File.open(fout, 'w')
out.puts "# #{ARGV[0]} disassembly into #{ARGV[1]}"

bc.codes.each {|c| out.puts c.to_s }

out.close
