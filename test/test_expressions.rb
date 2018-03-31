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
end