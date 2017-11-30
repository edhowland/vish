#!/usr/bin/env ruby 
# evil.rb - evaluator for tiny stack lang

postfixen  = [1,2,3, :+, :*]
stack = []


def evil(l, s)
  e = l.each
  loop do
  begin
    v = e.next
    if v.instance_of? Symbol
      r = s.pop
      le = s.pop
      result = le.send v, r
      s.push result
    else
      s.push  v
    end
  rescue StopIteration
    break
  end
  end
end


evil postfixen, stack

p stack