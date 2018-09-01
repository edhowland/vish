#!/usr/bin/env ruby
# opt2.rb - insert a new block into OptionParser block
require 'optparse'
require_relative '../lib/vish'

def get_options(pgm:'', desc:'', options:{}, &blk)
  OptionParser.new do |o|
    o.banner = "#{pgm}  - #{desc}"
  o.separator  ''
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
  yield o if block_given?

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
#
end