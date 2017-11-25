#!/usr/bin/env ruby
# vre.rb - vre CLI tool to run .vshc bytecodes files, like JRE

require_relative '../common/load_codes'
# TODO: Make this much shorter, only require actual requires
require_relative '../lib/vish'

#require_relative '../code_interperter'


file = File.open(ARGV.first, 'r')
bc, ctx = load_codes file
ci = CodeInterperter.new bc, ctx
ci.run
