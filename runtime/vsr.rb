#!/usr/bin/env ruby
# vsr.rb - vre CLI tool to run .vsc bytecodes files, like JRE
require "optparse"

require_relative "vish_runtime"

opt=OptionParser.new do |o|
  o.banner = "vsr - Runtime for compiled Vish symcode files: *.vsc\nUsage: vsr myfile.vsc"
  o.separator ""
  o.on("-r file", "--require file", String, "Require file before executing runtime") do |file|
#    require file
  end
  o.separator ""

  o.on("-h", "--help", "Display this help") do
    puts o
    exit(0)
  end
  o.on("-v", "--version", "Display the version of Vish") do
    puts "Vish version #{Vish::VERSION}"
    exit(0)
  end
end

opt.parse!
file = File.open(ARGV.first, "r")
bc, ctx = load_codes file
ci = CodeInterpreter.new bc, ctx
p ci.run
