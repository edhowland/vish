def ht(arr)
  return arr.shift, *arr
end

def rev(arr, o=[])
  return o if arr.empty?
  h, *t = ht(arr)
  o.unshift h
  rev(t, o)
end