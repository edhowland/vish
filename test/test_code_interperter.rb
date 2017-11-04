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
  def test_decode_raises_opcode_error_when_given_gibberish
    @bc.codes = [:xyzzy]
    code = @ci.fetch
    assert_raises OpcodeError do
      @ci.decode code
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
  def test_can_sub
    @ctx.constants = [5,2]
    @bc.codes = [:pushc,0,:pushc,1,:sub,:debug,:halt]
    @ci.run
    assert_eq @result, 3
  end
  def test_can_mult
    @ctx.constants = [18,10]
    @bc.codes = [:pushc, 0, :pushc, 1, :mult, :debug, :halt]
    @ci.run
    assert_eq @result, 180
  end
  def test_can_div
    @ctx.constants = [500,10]
    @bc.codes = [:pushc, 0, :pushc, 1, :div, :debug, :halt]
    @ci.run
    assert_eq @result, 50
  end
  def test_cls
    @ctx.constants = [0]
    @bc.codes = [:cls, :pushc, 0, :cls, :halt]
    @ci.run
    assert @ctx.stack.empty?
  end

  # branching bytecodes
  def test_jmp_fwd
  @ctx.constants = [3,4,5,6]
    @bc.codes = [:cls, :pushc, 0, :pushc, 1, :add, :jmp, 13, :pushc, 2, :pushc, 3, :mult, :debug, :halt]
    @ci.run
    assert_eq @result, 7
  end
end
