# tails.rb - helpers for tail call optimization
def tco
  TailCall.new
end

def notail
  compile '->() {1;2}'
end
def two_tailcalls
  compile '->() { %f; %g}'
end
def tailcall
  compile '->() { 1; %f}'
end
def condtail
  compile '->() { true && %f}'
end
def condnot
  compile '->() {true && false}'
end