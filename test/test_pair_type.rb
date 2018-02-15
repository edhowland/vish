# pair_type.rb - tests for  PairType

require_relative 'test_helper'


class TestPairType < BaseSpike
  def set_up
    @p = PairType.null
  end
  def test_null_is_null_pair_type
    assert PairType.null?(@p)
  end
  def test_not_null_is_not_null
    p = PairType.new key: :a, value: 9
    assert_false PairType.null?(p)
  end
  def test_can_set_value
    p = PairType.new key: :a, value: 9
    p.value = 3
    assert_eq p.value, 3
  end
end