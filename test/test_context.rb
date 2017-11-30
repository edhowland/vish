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

  # test merging merging Contexts
  # Useful for ./bin/repl.rb
  def test_context_can_be_merged_with_new_context
    ctx = Context.new
    ctx.constants = [1,2,3]
    ctx.vars = {name: 'hello', var: 'world'}
nctx = Context.new
nctx.constants = [4,5]
nctx.vars = {bye: 'goodbye'}
mctx = ctx.merge nctx
assert_eq mctx.constants, [1,2,3,4,5]
  end
end