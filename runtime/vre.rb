#!/usr/bin/env ruby
# vre.rb - vre CLI tool to run .vshc bytecodes files, like JRE

require_relative 'load_codes'
require_relative '../code_interperter'


file = File.open(ARGV.first, 'r')
bc, ctx = load_codes file
ci = CodeInterperter.new bc, ctx
ci.run
