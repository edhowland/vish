# test_icall.rb - test for icall bytecode

require_relative 'test_helper'

class TestIcall < BaseSpike
  include CompileHelper
  def set_up
    @bc = ByteCodes.new
    @ctx = Context.new
  end

  def test_icall_calls_echo
    @bc.codes = [:cls, :pushl, :echo, :icall, :print, :halt]
    ci = mkci @bc, @ctx
    ci.run
  end
end
