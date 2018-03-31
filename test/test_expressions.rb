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
end