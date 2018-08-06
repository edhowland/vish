# gen.rb - method gen w/continuation


$k=nil
def gen
  init = false
  while true do 
    callcc {|k| $k = k}
    if not init
      init = true
      x = 0
      return
    end
    x = x + 1
    return x
  end
end
