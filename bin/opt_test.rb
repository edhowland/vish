#!/usr/bin/env ruby

# opt_test.rb - check opt2.rb
require_relative 'opt2'


opts = get_options(pgm:'opt2.rb', desc:'test for opt2 with embedded yield', options:{}) do |o|
  o.on('-e expression', '--evaluate expression', String, 'Evaluates given expression') do |expr|
    puts "you asked me to evaluate: #{expr}"
    exit(0)
  end
end

opts.parse!
