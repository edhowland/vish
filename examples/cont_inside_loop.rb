require 'continuation'

  def look
            for i in 1..5 do
                  puts i
                      callcc {|continuation| return continuation} if i== 2
                        end           # cont.call returns here
               return nil
end  
puts "Before loop call"
cont=look( )
puts "After loop call"
cont.call if cont
puts "After continuation call"
