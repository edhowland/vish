#!/usr/bin/env ruby
# vsr.rb - vre CLI tool to run .vsc bytecodes files, like JRE

require_relative '../common/load_codes'
# TODO: Make this much shorter, only require actual requires
require_relative '../lib/vish'

file = File.open(ARGV.first, 'r')
bc, ctx = load_codes file
ci = CodeInterpreter.new bc, ctx
p ci.run
