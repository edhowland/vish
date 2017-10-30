#!/usr/bin/env ruby
# vasm.rb - assembles .vasm files into .vshc bytecode files

require_relative 'vasm_grammar'


fin, fout = ARGV

parser = VasmGrammar.new


input = File.read(fin)
p parser.parse(input)
