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
end