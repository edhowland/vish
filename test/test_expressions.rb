# test_expressions.rb - test for various mathematical expressions

require_relative 'test_helper'


class TestExpressions < BaseSpike
  include CompileHelper
  def test_equality
    assert interpret '2 == 2'
  end
  def test_inequality
    assert interpret('2 != 3')
  end
  def test_less_than
    assert interpret('2 < 6')
  end
  def test_less_than_or_equality
    assert interpret('2 <= 2')
  end
  # greater
  def test_greater_than
    assert interpret('3>2')
  end
  def test_greater_than_or_equal
    assert interpret('3 >= 3')
  end
  #
  # unary negative : -2, -:a, -(4+:a)
  def test_can_negate_integer
    assert_eq interpret('-2'), -2
  end
  def test_negate_variable
    assert_eq interpret('a=19;- :a'), -19
  end
  def test_can_negate_paren_expression
    assert_eq interpret('-(7 * 3)'), (- (7 * 3))
  end

  def test_compare_2_symbols
    assert interpret('foo: == foo:')
  end

  # eq? - 2 objects  are the same object
  def test_eq_2_ints_are_same
    assert interpret('eq?(1,1)')
  end
  def test_variable_refers_to_same_object
    assert interpret('a=9;eq?(:a, 9)')
  end
  def test_not_eq_for_differents_ints
    assert_false interpret('eq?(3,4)')
  end
  def test_vectors_are_not_the_same
    assert_false interpret('a=[1,2];eq?(:a, [1,2])')
  end
  # associativity for power operator: ** should be right assoc
  def test_right_assoc_of_power_op
    assert_eq interpret('2 ** 3 ** 2'), 512
  end
end