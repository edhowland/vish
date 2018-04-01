# xp.rb - method xp - like p, but also does xinspect - extended inspect

def xp(obj)
  if obj.respond_to? :xinspect
    print obj.xinspect
  else
    print obj.inspect
  end
end
