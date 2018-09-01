# cont.rb - example Continuation code

arr = [ "Freddie", "Herbie", "Ron", "Max", "Ringo" ]
callcc{|cc| $cc = cc}
puts(message = arr.shift)
$cc.call unless message =~ /Max/
