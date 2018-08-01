
require 'continuation'

def main
  i = 0
    callcc do |label| # callcc gives us label, a continuation object
        puts i
            label.call # this is our "goto" statement
                i = 1      # we skip this completely  
                  end
                  # The inner call to label jumps to here
                  puts 'got here'
puts i
                  end

puts 'about to call main'
main
