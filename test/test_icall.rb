# test_icall.rb - test for icall bytecode

require_relative 'test_helper'

class TestIcall < BaseSpike
  include CompileHelper
  def set_up
  @parser, @transform = parser_transformer
    @bc = ByteCodes.new
    @ctx = Context.new
  end

  def test_icall_calls_echo
  @ctx.constants = [0, 1]
    @bc.codes = [:cls, :pushc, 0, :pushc, 1, :pushl, :echo, :icall, :halt]
    ci = mkci @bc, @ctx
    ci.run
  end

  # compile stuff
  def test_try_echo_with_one_arg
    result = interpret 'echo(3+4)'
    assert_eq result, "7\n"
  end
  def test_empty_arglist
    ir = @parser.parse 'echo( )'
  end
end
