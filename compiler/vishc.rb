#!/usr/bin/env ruby
# vishc.rb - compile vish program into bytecode
# The format of the bytecode is a Ruby Marshall serialized object after
# The ByteCodes, Context after they been compiled.
# Usage: ./vishc -o file.vsc file.vs [file2.vs, ...]

require 'optparse'
require 'erb'
require_relative '../lib/vish'
require_relative '../common/store_codes'

@options = {
  check: false,
  compile: false,
  deprecations: false,
  stdlib: true,
  ofile: 'v.out.vsc',
  template: 'vish.erb',
  ruby: false,
  requires: []
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
  o.on('-R', '--ruby', 'Compile into Ruby output file.rb') do
    @options[:ruby] = true
@options[:compile] = false
  end
  o.on('-t file', '--template file', String, 'Use file.erb as template instead of vish.erb') do |file|
    @options[:template] = file
  end
  o.on('-r file', '--require file', String, 'Add this required  gem or Ruby file into generated output .rb') do |file|
    @options[:requires] << file
  end
    o.separator '=================================================='

    o.on('-d', '--deprecations', 'Show any deprecation warnings for files and exit with status code:9') do
      @options[:deprecations] = true
      @options[:stdlib] = false
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
    source = File.read(stdlib) + "\nversion='#{Vish::VERSION}'\n" + source
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
    $stderr.puts "Syntax Error: #{failure.message}"
  $stderr.puts failure.parse_failure_cause.ascii_tree
  1
  rescue CompileError => err
  $stderr.puts "Compile error: #{err.message}"
    2
  end
end

if @options[:check]
  exit(check(compose(ARGF.read)))
end

def deprecated?(source)
  c = VishCompiler.new source
  c.run
  c.check ? 9 : 0
end

if @options[:deprecations]
  exit(deprecated?(compose(ARGF.read)))
end

def compile(source, ofile)
  result = false
begin
  compiler = VishCompiler.new source
  compiler.run

  # now write it out to file.vshc
io = File.open(ofile, 'w')
  store_codes(compiler.bc, compiler.ctx, io)
  result = true
rescue Parslet::ParseFailed => failure
  $stderr.puts failure.parse_failure_cause.ascii_tree
rescue => err
  $stderr.puts err.class.name
  $stderr.puts err.message
  end
  result
end

# render Ruby source file with ERB
def render opt=@options
  template = File.read('vish.erb')
  renderer = ERB.new(template)
  output = renderer.result()
File.write(opt[:ofile], output)
end

if @options[:compile] and !@options[:ruby]
  result = compile(compose(ARGF.read), @options[:ofile])
  exit([true,false].index(result))
elsif @options[:ruby]
  render
end
