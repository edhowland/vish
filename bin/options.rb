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
