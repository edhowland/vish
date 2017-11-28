# test_interrupt.rb - tests for :int, :iret, handlers and stuff

require_relative 'test_helper'

class TestInterrupt < BaseSpike
  include InterpreterHelper

  def test_default_interrupt_handler_is_called
    @bc.codes = [:int, :_default, :halt]
    @ci.run
  end
  # interrupt handler stuff
  def test_int_w_unknown_handler_name_just_does_default
    @bc.codes = [:cls, :int, :_xxx, :halt]
    @ci.run
  end
  def test_default_interpeter_is_called_and_no_exception_is_raised
    @bc.codes = [:cls, :int, :_default, :halt]
    @ci.run
  end
#  def test_error_state_works
#    @bc.codes = [:error, '']
#    assert_raises ErrorState do
#      @ci.run
#    end
#  end
  def test_exit_handler_is_installed_by_default
    @bc.codes = [:int, :_exit]
    @ci.run
  end

  # test out break handler stuff, :dup, :unwind, :pusht, :loadt
  def test_dup_actually_duplicates_the_top_of_the_stack
    @ctx.stack.push :xxx
    @bc.codes = [:dup, :halt]
    @ci.run
    assert_eq @ctx.stack.peek, :xxx
    assert_eq @ctx.stack[-2], :xxx
  end
  def test_loadt_loads_top_of_stack_into_ci_register_a
    @ctx.stack.push :yyy
    @bc.codes = [:loadt, :halt]
    @ci.run
    assert_eq @ci.register_a.value, :yyy
  end
  def test_pusht_pushes_contentsci_register_a_onto_stack
    @bc.codes = [:cls, :pusht, :halt]
    @ci.register_a.load(:yes)
    @ci.run
    assert_eq @ctx.stack.peek, :yes
  end
  def test_unwind_unrolls_the_call_stack_one_item_and_pushes_it_on_stack
    @ctx.call_stack.push :thing
    @bc.codes = [:cls, :unwind, :halt]
    @ci.run
    assert_eq @ctx.call_stack.length, 0
    assert_eq @ctx.stack.peek, :thing
  end

  # test simple :irets
  def test_simple_int_then_iret
    @bc.codes = [:int, :_simple, :halt]
    nbc = ByteCodes.new
    nbc.codes = [:iret]
    nctx = Context.new
    @ci.handlers[:_simple] = [nbc, nctx]
    @ci.run
  end
end