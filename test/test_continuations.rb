# test_continuations.rb - tests for

require_relative 'test_helper'

class TestContinuations < BaseSpike
#  include WithStdLib
include CompileHelper
def set_up
  @stdlib = File.read(stdlib()) + "\n"
end
  def test_stdlib
    x = interpret @stdlib + '1'
  end
  def test_call_stdlib
    x = interpret @stdlib + 'o=~{foo: 1};keys(:o)'
    assert_eq x, [:foo]
  end

  def _test_one
    x = interpret 'car(foo: 1)'
    assert_eq x, :foo
  end
  def _test_keys
    x=interpret 'keys(~{foo: 1, bar: 2})'
    assert_eq x, [:foo, :bar]
  end
  def _test_compile
    bc, ctx = compile 'keys(~{foo: 1})'
    ci=CodeInterpreter.new bc, ctx
    assert_eq ci.run, [:foo]
  end
end
