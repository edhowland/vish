# test_lcall.rb - tests to move lambda call into Lambda object, from :ncall opcode
require_relative 'test_helper'
class TestLCall < BaseSpike
  include CompileHelper

  def set_up
    @ci = CodeInterpreter.new ByteCodes.new, Context.new
    @l = interpret 'defn foo(a, b) {}'
  end
  def test_perform_checks_arity
    l = interpret 'defn foo(a, b) {}'
    @ci.ctx.stack.push 10
    @ci.ctx.stack.push 20
    @ci.ctx.stack.push 30
    @ci.ctx.stack.push 3
    assert_raises VishArgumentError do
      x = l.perform(@ci)
    end
  end
  def test_perform_works_with_correct_arity
    l = interpret 'defn foo(a, b) {}'
    [10, 20, 2].each {|n| @ci.ctx.stack.push n }
    l.perform(@ci)
  end
  def test_perform_constructs_new_frame_on_call_stack
    [10, 20, 2].each {|n| @ci.ctx.stack.push n}
    curr = @ci.frames.length
    @l.perform(@ci)
    assert_eq @ci.frames.length, curr + 1
  end
  def test_perform_sets_ret_code
    [10, 20, 2].each {|n| @ci.ctx.stack.push n}
    @ci.bc.pc += 1
    @l.perform(@ci)
    assert_eq @ci.frames.peek.return_to, 1
  end
  def test_perform_sets_pc_to_loc_of_lambda
        [10, 20, 2].each {|n| @ci.ctx.stack.push n}
    @l.perform(@ci)
    assert_eq @ci.bc.pc, @l[:loc]
  end
  def test_perform_args_are_pushed_onto_frame_data_stack
            [10, 20, 2].each {|n| @ci.ctx.stack.push n}

@l.perform(@ci)
assert_eq @ci.frames.peek.ctx.stack.length, 2
  end
  # test :lcall itself
  def test_set_up_and_lcall
    @ci.bc.codes = [:pushl, 10, :pushl, 20, :pushl, 2, :pushl, @l, :lcall]
    @ci.run
  end
  def test_lcall_from_compiled_code_works
    bc, ctx = compile 'defn foo(a, b) {:a+:b};foo(2,3)'
    ndx = bc.codes.index :ncall
    bc.codes[ndx] = :lcall
    ci = CodeInterpreter.new bc, ctx
    result = ci.run
    assert_eq result, 5
  end

  # internal function lcalls with varidic args
  def test_lcall_to_cat_with_3_args
    bc, ctx = compile 'cat(1,2,3)'
    ndx = bc.codes.index :ncall
    bc.codes[ndx] = :lcall    
    ci = CodeInterpreter.new bc, ctx
    assert_eq ci.run, '123'
  end
  def test_lcall_internal_function_with_non_varidiac_args
    bc, ctx = compile 'dup(9)'
    ndx = bc.codes.index :ncall
    bc.codes[ndx] = :lcall
    ci = CodeInterpreter.new bc, ctx
    assert_eq ci.run, 9
  end
end

