# test_builtins.rb - tests for builtin methods

require_relative 'test_helper'

class TestBuiltins < BaseSpike
  include CompileHelper
  def test_unknown_fn_call_raises
    assert_raises UnknownFunction do
      interpret 'foo()'
    end
  end
end