require 'continuation'


$k = nil

def mm
5 + callcc {|k| $k = k; k[3]}
end

def nn
  $k[99]
  puts 'after call. Should not ever see this!'
  end
