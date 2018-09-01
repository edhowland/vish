# test_context.rb - class TestContext < BaseSpike

require_relative 'test_helper'


class TestContext < BaseSpike
  def set_up
    @ctx = Context.new
  end
  def test_starting_stack_empty
    assert @ctx.stack.empty?
  end
  def test_has_empty_constants
    assert @ctx.constants.empty?
  end
  def test_empty_vars
    assert @ctx.vars.empty?
  end
  # _clone
  def test_underbar_clone
    x = Context.new
    x.stack.push 1,2,3
    y = x._clone
    assert_eq y.stack.pop(3), [1,2,3]
  end
end
