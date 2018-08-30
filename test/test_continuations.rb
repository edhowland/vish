# test_continuations.rb - tests for Continuation

require_relative 'test_helper'

class TestContinuations < BaseSpike
#  include WithStdLib
include CompileHelper
def set_up
  @stdlib = File.read(stdlib()) + "\n"
end
  def test_callcc_just_returns
    result = interpret @stdlib + %q{"hello %{callcc(->(k) { 'world'})}"}
    assert_eq result, 'hello world'
  end
  def test_cycle_thru_continuation
    src =<<-EOC
# h.vs - hello. world w/continuation
r=callcc(->(k) { :k })
r(->(a) { 'ok' })
EOC
    result = interpret @stdlib + src
    assert_eq result, 'ok'
  end
  def test_can_escape_when_0_is_reached
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