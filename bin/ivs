#!/usr/bin/env ruby
# ivs.rb - New and improved interactive Vish shell



require_relative '../lib/vish'


eval = Evaluator.new
loop do
  begin
    print 'vish> '
    source = gets.chomp
    break if source =~ /break|exit|quit/#
    p eval.eval source
  rescue => err
    puts "Syntax Error: #{err.message}"
  end
end
