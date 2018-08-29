# test_continuations.rb - tests for

require_relative 'test_helper'

class TestContinuations < BaseSpike
#  include WithStdLib
include CompileHelper
def set_up
  @stdlib = File.read(stdlib()) + "\n"
end
  def test_mult0
    src =<<-EOC
# mult0.vs - multiply items in list unless 0 is encountered, then return via continuation
defn mult(l) {
  callcc(->(k) {
defn mult0(ls) {
  null?(:ls) && return 1
  zero?(car(:ls)) && k(0)
  car(:ls) * mult0(cdr(:ls))
}
  mult0(:l)
  })
}
mult(list(2,3,4,0,5,6,7))
EOC
    result = interpret @stdlib + src
        assert  result.zero?
  end
end