# options.rb - common optparse stuff

require 'optparse'

def get_options
OptionParser.new do |o|
  o.banner = 'ivs - REPL for Vish runtime'
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
