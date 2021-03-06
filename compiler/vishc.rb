#!/usr/bin/env ruby
# vishc.rb - compile vish program into bytecode
# The format of the bytecode is a Ruby Marshall serialized object after
# The ByteCodes, Context after they been compiled.
# Usage: ./vishc -o file.vsc file.vs [file2.vs, ...]

require 'optparse'
require 'erb'
require 'fileutils'
require_relative '../lib/vish'
require_relative '../common/store_codes'

@options = {
  check: false,
  compile: true,
  deprecations: false,
  stdlib: true,
  ofile: 'v.out.vsc',
loads: [],
  template: vish_path('/bin/vish.erb'),
  ruby: false,
  requires: [],
includes: []
}
opt = OptionParser.new do |o|
  o.banner = 'Vish compiler'
  o.separator ''

  o.on('-c', '--check', 'Check syntax') do
    @options[:check] = true
    @options[:compile] = false
  end
  o.on('--no-stdlib', 'Do not preload Vish standard lib first') do
    @options[:stdlib] = false
  end
  o.on('-o file', '--output file', String, 'Output to file') do |file|
    @options[:ofile] = file
    @options[:compile] = true
  end
  o.on('-l file', '--load file', String, 'Loads Vish sources files to be compiled before target.vs') do |file|
    @options[:loads] << file
  end
  o.on('-R', '--ruby', 'Compile into Ruby output file.rb') do
    @options[:ruby] = true
@options[:compile] = false
  end
  o.on('-t file', '--template file', String, 'Use file.erb as template instead of vish.erb') do |file|
    @options[:template] = file
  end
  o.on('-r file', '--require file', String, 'Add this required  gem or Ruby file into generated output .rb') do |file|
    @options[:requires] << file.pathmap('%d/%f')
  end
  o.on('-i file', '--include file', String, 'Include file in Ruby output file') do |file|
    @options[:includes] << file
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
  source = opts[:loads].map {|f| File.read(f) }.join("\n") + "\n" + source + "\n"
  if opts[:stdlib]
    source = File.read(stdlib) + source
  end
  source
end


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
  exit(check(compose(File.read(ARGV[0]))))
end

def deprecated?(source)
  c = VishCompiler.new source
  c.run
  c.check ? 9 : 0
end

if @options[:deprecations]
  exit(deprecated?(compose(File.read(ARGV[0]))))
end
def save compiler, ofile
io = File.open(ofile, 'w')
  store_codes(compiler.bc, compiler.ctx, io)
end


def compile source
  result = false
begin
  compiler = VishCompiler.new source
  compiler.run
  result = true
rescue Parslet::ParseFailed => failure
  $stderr.puts failure.parse_failure_cause.ascii_tree
rescue => err
  $stderr.puts err.class.name
  $stderr.puts err.message
  end
  [compiler, result]
end

# render Ruby source file with ERB
def render compiler, opt=@options
  template = File.read(opt[:template])
  renderer = ERB.new(template)
  output = renderer.result(binding)
File.write(opt[:ofile], output)
  FileUtils.chmod('+x', opt[:ofile])
end

if __FILE__ == $0
if ARGV.empty?
  $stderr.puts 'Must supply a single source file to check or compile'
  exit(1)
end

if  ! File.exist?(ARGV[0])
  $stderr.puts "File #{ARGV[0]} does not exist"
  exit(1)
end


if @options[:compile] and !@options[:ruby]
  compiler, result = compile(compose(ARGF.read))
save compiler, @options[:ofile] if result 
elsif @options[:ruby]
  compiler, result = compile(compose(File.read(ARGV[0]))) 
  if result
    render(compiler) 
  else
    $stderr.puts "Could not create output Ruby file: #{@options[:ofile]} because of compiler error."
  end
end

  exit([true,false].index(result))
end
