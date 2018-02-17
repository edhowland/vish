# options.rb - common optparse stuff

require 'optparse'

def get_options(pgm='ivs', desc="REPL for Vish runtime", &blk)
  options = yield if block_given?
OptionParser.new do |o|
  o.banner = "#{pgm}  - #{desc}"
  o.separator  ''
    o.on('--no-stdlib', 'Do not preload standard library functions') do
      options[:stdlib] = false
    end
    o.on('-l file', '--load file', String, 'Load additional files before starting REPL') do |file|
      options[:ifiles] ||= []
      options[:ifiles] << file
    end
    o.on('-r file', '--require file', String, 'Require extra file before starting') do |file|
      require file
    end
    o.separator '=================================================='
    o.on('-d', '--deprecations', 'Show any deprecation warnings for files and exit with status code:9') do
      options[:deprecations] = true
    end
  o.separator  ''

  o.on('-h', '--help', 'Display this help') do
    puts o
    exit(0)
  end
  o.on('-v', '--version', 'Display this version') do
    puts "Vish version #{Vish::VERSION}"
    exit(0)
  end
end
end
