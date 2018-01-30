#!/usr/bin/env ruby
# vishc.rb - compile vish program into bytecode
# The format of the bytecode is a Ruby Marshall serialized object after
# The ByteCodes, Context after they been compiled.
# Usage: ./vishc file.vsh file.vshc

require 'optparse'
require_relative '../lib/vish'
require_relative '../common/store_codes'

@options = {
  check: false,
  compile: false,
  stdlib: true,
  ofile: 'v.out.vsc'
}
opt = OptionParser.new do |o|
o.banner = 'Vish compiler'
o.separator ''
  o.on('-c', '--check', 'Check syntax') do
    @options[:check] = true
  end
  o.on('--no-stdlib', 'Do not preload Vish standard lib first') do
    @options[:stdlib] = false
  end
  o.on('-o file', '--output file', String, 'Output to file') do |file|
    @options[:ofile] = file
    @options[:compile] = true
  end
  o.separator ''
  o.on('-h', '--help', 'Display this help') do |op|
    puts o
    exit(0)
  end
  o.on('-v', '--version', 'Report version of Vish language') do
    puts "Vish version: #{Vish::VERSION}"
    exit(0)
  end
end
opt.parse!

def compose(source, opts=@options)
  if opts[:stdlib]
    source = File.read(stdlib) + "\n" + source
  end
  source
end

#source = ARGF.read

# Possibly add in Vish StdLib stuff


def check(source)
    compiler = VishCompiler.new source
  begin
    compiler.parse
    compiler.transform
    compiler.analyze
    puts 'Syntax OK'
    0
rescue Parslet::ParseFailed => failure
    puts "Syntax Error: #{failure.message}"
  puts failure.parse_failure_cause.ascii_tree
  1
  rescue CompileError => err
  puts "Compile error: #{err.message}"
    2
  end
end

if @options[:check]
  exit(check(source))
end

def compile(source, ofile)
exit_status = 1
begin
  compiler = VishCompiler.new source
  compiler.run

  # now write it out to file.vshc
io = File.open(ofile, 'w')
  store_codes(compiler.bc, compiler.ctx, io)
  exit_status = 0
rescue Parslet::ParseFailed => failure
  puts failure.parse_failure_cause.ascii_tree
rescue => err
  puts err.class.name
  puts err.message
  end


exit(exit_status)

end

if @options[:compile]
  compile(compose(ARGF.read), @options[:ofile])
end
