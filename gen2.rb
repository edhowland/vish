# 2nd attempt of gen in Ruby w/continuation

# Usage:
# x, cc = gen
# cc.call
# => x will be 1
# cc.call
# => x will be 2
# cc.call
# => x will be 3
# ...
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
        return [nil, kk]
      end
      i += 1
      return [i, kk]
    end
    callcc {|k| kk=k }
  end
end