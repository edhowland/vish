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
  def test_conditional_branch_jmpt
    @ctx.constants = [0,0,5]
    @bc.codes = [:cls, :pushc, 0, :pushc, 1, :eq, :jmpt, 11, :cls, :pushc, 0, :cls, :pushc, 2, :debug, :halt]
    @ci.run
    assert_eq @result, 5
  end
  # Should simulate a if/then/else branch
  def test_jmpt_does_not_branch_when_tos_is_false
    @ctx.constants = [1,0,5]
    @bc.codes = [:cls, :pushc, 0, :pushc, 1, :eq, :jmpt, 13, :cls, :pushc, 0, :jmp, 16, :cls, :pushc, 5, :debug, :halt]
    @ci.run
    assert_eq @result, 1
  end
  # negative branch. branch if false at top of stack
  def test_jmpf_branches_if_top_of_stack_is_false
    @ctx.constants = [false, 'ok']
    @bc.codes = [:cls, :pushc, 0, :jmpf, 7, :pushl, 15, :pushc, 1, :debug, :halt]
    @ci.run
    assert_eq @result, 'ok'
  end
  def test_jmpf_does_not_branche_if_top_of_stack_is_true
    @ctx.constants = [true, 'ok']
    @bc.codes = [:cls, :pushc, 0, :jmpf, 9, :pushl, 15, :jmp, 11, :pushc, 1, :debug, :halt]
    @ci.run
    assert_eq @result, 15
  end

  # comparison operators
  def test_eq
    @ctx.constants = [0,0]
    @bc.codes = [:cls, :pushc, 0, :pushc, 1, :eq, :debug, :halt]
    @ci.run
    assert @result
  end
  def test_eq_finds_non_equality
    @ctx.constants = [1,0]
    @bc.codes = [:cls, :pushc, 0, :pushc, 1, :eq, :debug, :halt]
    @ci.run
    assert_false @result
  end
  def test_neq_finds_non_equality_and_pushes_true
        @ctx.constants = [1,0]
    @bc.codes = [:cls, :pushc, 0, :pushc, 1, :neq, :debug, :halt]
    @ci.run
    assert @result
  end
  def test_neq_finds_equality_and_pushes_false
            @ctx.constants = [1,1]
    @bc.codes = [:cls, :pushc, 0, :pushc, 1, :neq, :debug, :halt]
    @ci.run
    assert_false @result
  end
  
  # test logical opcodes :or, :and
  def test_and_pushes_true_when_2_tos_are_both_true
    @ctx.constants = [true, true]
    @bc.codes = [:cls, :pushc, 0, :pushc,  1, :and, :debug, :halt]
    @ci.run
    assert @result
  end
  def test_or_pushes_true_w_2_tos_are_both_true
        @ctx.constants = [true, true]
    @bc.codes = [:cls, :pushc, 0, :pushc,  1, :and, :debug, :halt]
    @ci.run
    assert @result
  end
  def test_not_gets_true_when_gets_false
    @ctx.constants = [false]
    @bc.codes = [:cls, :pushc, 0, :not, :debug, :halt]
    @ci.run
    assert @result
  end
  def test_not_is_false_when_is_true
    @ctx.constants = [true]
    @bc.codes = [:cls, :pushc, 0, :not, :debug, :halt]
    @ci.run
    assert_false @result
  end

  def test_code_can_exist_after_halt_bytecode
  @ctx.constants = [100, 4, 99]
    @bc.codes = [:cls, :pushc, 0, :pushc, 1, :div, :debug, :halt, :cls, :pushc, 2, :debug]
    @ci.run
    assert_eq @result, 25
  end
  def test_can_modulo
    @ctx.constants = [4,2]
    @bc.codes = [:pushc, 0, :pushc, 1, :mod, :debug, :halt]
    @ci.run
    assert @result.zero?
  end
  def test_star_star_raises_2_squared_is_4
    @ctx.constants = [2,2]
    @bc.codes = [:pushc, 0, :pushc, 1, :exp, :debug, :halt]
    @ci.run
    assert_eq @result, 4
  end

  # thing to convert top of stack to a string, push the result as a string
  def test_str_opcode
    @ctx.constants = [11]
    @bc.codes = [:cls, :pushc, 0, :str, :debug, :halt]
    @ci.run
    assert_eq @result, '11'
  end
end
