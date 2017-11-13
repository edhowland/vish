# test_bytecodes.rb - class TestByteCodes < BaseSpike

require_relative 'test_helper'

class TestByteCodes < BaseSpike
  def set_up
    @bc = ByteCodes.new
  end
  def test_has_zero_pc
    assert_eq @bc.pc, 0
  end
  def test_has_empty_starting_codes
    assert @bc.codes.empty?
  end
end