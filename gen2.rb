# 2nd attempt of gen in Ruby w/continuation
require 'continuation'

def gen
  init = true
  not_primed = true
  kk = nil
  while true do
    if init
      init = false
  i = 0
    else
      if not_primed
        not_primed = false
        return kk
      end
      i += 1
      return i
    end
    callcc {|k| kk=k }
  end
end