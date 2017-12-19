# test_code_interpreter.rb - class TestCodeInterpreter < BaseSpike

require_relative 'test_helper'

class TestCodeInterpreter < BaseSpike
  def set_up
    @bc = ByteCodes.new
    @ctx = Context.new
    @result = nil
    @ci = CodeInterpreter.new(@bc, @ctx)
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
    @bc.codes = [:pushc, 0, :pushc, 1, :add, :halt]
    assert_eq @ci.run, 15
  end
  def test_assign
    @ctx.constants = [55]
    @bc.codes = [:pushl, 'name', :pushc, 0, :assign, :halt]
    @ci.run
    assert_eq @ctx.vars['name'], 55
  end
  def test_resolve_var_onto_stack
    @ctx.vars['var1'] = 100
    @bc.codes = [:pushv, 'var1', :halt]
    assert_eq @ci.run, 100
  end
  def test_can_sub
    @ctx.constants = [5,2]
    @bc.codes = [:pushc,0,:pushc,1,:sub,:halt]
    assert_eq @ci.run, 3
  end
  def test_can_mult
    @ctx.constants = [18,10]
    @bc.codes = [:pushc, 0, :pushc, 1, :mult,  :halt]
    assert_eq @ci.run,  180
  end
  def test_can_div
    @ctx.constants = [500,10]
    @bc.codes = [:pushc, 0, :pushc, 1, :div,  :halt]
    assert_eq @ci.run, 50
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
    @bc.codes = [:cls, :pushc, 0, :pushc, 1, :add, :jmp, 13, :pushc, 2, :pushc, 3, :mult,  :halt]
    assert_eq @ci.run, 7
  end
  def test_conditional_branch_jmpt
    @ctx.constants = [0,0,5]
    @bc.codes = [:cls, :pushc, 0, :pushc, 1, :eq, :jmpt, 11, :cls, :pushc, 0, :cls, :pushc, 2,  :halt]
    assert_eq @ci.run, 5
  end
  # Should simulate a if/then/else branch
  def test_jmpt_does_not_branch_when_tos_is_false
    @ctx.constants = [1,0,5]
    @bc.codes = [:cls, :pushc, 0, :pushc, 1, :eq, :jmpt, 13, :cls, :pushc, 0, :jmp, 16, :cls, :pushc, 5,  :halt]
    assert_eq @ci.run, 1
  end
  # negative branch. branch if false at top of stack
  def test_jmpf_branches_if_top_of_stack_is_false
    @ctx.constants = [false, 'ok']
    @bc.codes = [:cls, :pushc, 0, :jmpf, 7, :pushl, 15, :pushc, 1,  :halt]
    assert_eq @ci.run, 'ok'
  end
  def test_jmpf_does_not_branche_if_top_of_stack_is_true
    @ctx.constants = [true, 'ok']
    @bc.codes = [:cls, :pushc, 0, :jmpf, 9, :pushl, 15, :jmp, 11, :pushc, 1,  :halt]
    assert_eq @ci.run, 15
  end

  # comparison operators
  def test_eq
    @ctx.constants = [0,0]
    @bc.codes = [:cls, :pushc, 0, :pushc, 1, :eq,  :halt]
    assert @ci.run
  end
  def test_eq_finds_non_equality
    @ctx.constants = [1,0]
    @bc.codes = [:cls, :pushc, 0, :pushc, 1, :eq,  :halt]
    assert_false @ci.run
  end
  def test_neq_finds_non_equality_and_pushes_true
        @ctx.constants = [1,0]
    @bc.codes = [:cls, :pushc, 0, :pushc, 1, :neq,  :halt]
    assert @ci.run
  end
  def test_neq_finds_equality_and_pushes_false
            @ctx.constants = [1,1]
    @bc.codes = [:cls, :pushc, 0, :pushc, 1, :neq,  :halt]
    assert_false @ci.run
  end

  # test logical opcodes :or, :and
  def test_and_pushes_true_when_2_tos_are_both_true
    @ctx.constants = [true, true]
    @bc.codes = [:cls, :pushc, 0, :pushc,  1, :and,  :halt]
    assert @ci.run
  end
  def test_or_pushes_true_w_2_tos_are_both_true
        @ctx.constants = [true, true]
    @bc.codes = [:cls, :pushc, 0, :pushc,  1, :and,  :halt]
    assert @ci.run
  end
  def test_not_gets_true_when_gets_false
    @ctx.constants = [false]
    @bc.codes = [:cls, :pushc, 0, :not,  :halt]
    assert @ci.run
  end
  def test_not_is_false_when_is_true
    @ctx.constants = [true]
    @bc.codes = [:cls, :pushc, 0, :not,  :halt]
    assert_false @ci.run
  end

  def test_code_can_exist_after_halt_bytecode
  @ctx.constants = [100, 4, 99]
    @bc.codes = [:cls, :pushc, 0, :pushc, 1, :div,  :halt, :cls, :pushc, 2, ]
    assert_eq @ci.run, 25
  end
  def test_can_modulo
    @ctx.constants = [4,2]
    @bc.codes = [:pushc, 0, :pushc, 1, :mod,  :halt]
    assert @ci.run.zero?
  end
  def test_star_star_raises_2_squared_is_4
    @ctx.constants = [2,2]
    @bc.codes = [:pushc, 0, :pushc, 1, :exp,  :halt]
    assert_eq @ci.run, 4
  end

  # thing to convert top of stack to a string, push the result as a string
  def test_str_opcode
    @ctx.constants = [11]
    @bc.codes = [:cls, :pushc, 0, :str,  :halt]
    assert_eq @ci.run, '11'
  end

  def test_bcall_jumps_tolocation_of_variable_on_tos
    @ctx.constants = ['_block_Assign_6', true]
    @ctx.vars[:name] = 'block_Assign_6'
    @ctx.vars[:_block_Assign_6] = 11
    @bc.codes = [:cls, :pushl, :name, :pushc, 0, :assign, :cls, :pushv, :name, :bcall,  :halt, :pushc, 1, :bret]

    assert @ci.run
  end

  # loop stuff
  def test_frame_opcode_pushes_frame_onto_stack
    l = LoopFrame.new;
    @bc.codes = [:frame, l, :halt]
    @ci.run
    assert_is @ci.frames.peek, LoopFrame
  end

  # test :swp - swaps top 2 items on stack
  def test_swp_swaps_top_2_items_on_stack
    @bc.codes = [:pushl, 0, :pushl, 1, :swp, :halt]
    @ci.run
    assert_eq @ctx.stack, [1, 0]
  end
  def test_stack_with_more_than_2_elements_swaps_top_2_items_leaving_rest_unchecnged
    @bc.codes = [:pushl, 0, :pushl, 1, :pushl, 2, :swp, :halt]
    @ci.run
    assert_eq @ctx.stack, [0, 2, 1]
  end
  def test_swap_with_0_elements_does_unknown
    @bc.codes = [:swp, :halt]
    @ci.run
    assert @ctx.stack.empty?
  end
end
