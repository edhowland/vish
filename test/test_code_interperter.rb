# test_code_interperter.rb - class TestCodeInterperter < BaseSpike

require_relative 'test_helper'

class TestCodeInterperter < BaseSpike
  def set_up
    @bc = ByteCodes.new
    @ctx = Context.new
    @result = nil
    # We hook into ctor for CodeInterperter to add a special opcode: debug 
    # which is a lambda to pop the item on the stack into @result
    @ci = CodeInterperter.new(@bc, @ctx) do |bc, ctx, bcodes|
      bcodes[:debug] = ->(bc, ctx) { @result = ctx.stack.pop }
    end
  end
  def test_can_add
    @ctx.constants = [5, 10]
    @bc.codes = [:pushc, 0, :pushc, 1, :add, :debug, :halt]
    @ci.run
    assert_eq @result, 15
  end
  def test_assign
    @ctx.constants = [55]
    @bc.codes = [:pushl, 'name', :pushc, 0, :assign, :halt]
    @ci.run
    assert_eq @ctx.vars['name'], 55
  end
  def test_resolve_var_onto_stack
    @ctx.vars['var1'] = 100
    @bc.codes = [:pushv, 'var1', :debug, :halt]
    @ci.run
    assert_eq @result, 100
    
  end
end