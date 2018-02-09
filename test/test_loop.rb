# test_loop.rb - tests for loop { stmnt; ... }

require_relative 'test_helper'

class TestLoop < BaseSpike
  include CompileHelper
  def test_loop_does_not_emit_int_bcode
    bc, ctx = compile 'loop { break }'
    assert_false bc.codes.member? :int
  end
  def test_break_exits_loop_early
    assert_eq interpret('val=0; loop { break; val=2 }; :val'), 0
  end
  def test_loop_breaks_out_after_some_conditional_has_been_met
    assert_eq interpret('var=0; loop { (:var == 10) && break; var=:var + 1 }; :var'), 10
  end

  def test_function_can_break_out_of_enclosing_loop
    interpret 'defn foo() {break};loop {foo()}'
  end
  def test_lambda_can_break_out_of_enclosing_loop
    interpret 'm=->() {break};loop { %m() }'
  end
  def test_can_really_break_out_of_loop_from_lambda_function_within_function
    interpret 'defn foo(bk) { %bk }; loop { foo(->() { break }) }'
  end
end