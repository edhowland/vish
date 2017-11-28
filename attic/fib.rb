# experimental - calc fibonnacci of last input

def fib(n)
  return n if (n.zero? || n == 1)

  return fib(n-2) + fib(n - 1)
end