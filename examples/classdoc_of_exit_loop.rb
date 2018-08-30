# cont2.rb - loop example
# This (somewhat contrived) example allows the inner loop to abandon processing early:

require "continuation"
callcc {|cont|
  for i in 0..4
      print "\n#{i}: "
          for j in i*5...(i+1)*5
                cont.call() if j == 17
                      printf "%3d", j
                          end
                            end
                            }
                            puts
#                             produces:

#                            0:   0  1  2  3  4
#                            1:   5  6  7  8  9
#                            2:  10 11 12 13 14
#                            3:  15 16
 