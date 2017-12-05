# test_function.rb - tests for functions, lambdas.

require_relative 'test_helper'

class TestFunctionFcall < BaseSpike
  include CompileHelper
  def run_until ci
    until (ci.peek == :fcall) do
      ci.step
    end
  end
  def emit(*args, loc:)
    ctx = Context.new
    ctx.constants = args
    bc = ByteCodes.new
    args.each_with_index {|c, i| bc.codes << :pushc; bc.codes << i }
    bc.codes << :pushl; bc.codes << args.length
    bc.codes << :fcall
    bc.codes << loc
    return bc, ctx
  end

  def set_up
    @ctx = Context.new
    @bc = ByteCodes.new
    @ci = CodeInterperter.new @bc, @ctx
  end

  # :fcall frame setup
  def test_fcall_creates_new_function_frame_on_stack
    # %blk()
    @bc, @ctx = emit(loc: 4)
    @bc.codes << :halt

    @ci = CodeInterperter.new @bc, @ctx
    run_until @ci
    @ci.step
    assert_is @ci.frames.peek, FunctionFrame
  end
  def test_can_pass_many_args_to_lambda
#    skip 'until after compile of actual function call'
    # %bk('a', 'b', 'c')
    @ctx.constants = ['a', 'b', 'c']

    @bc.codes = [:pushc, 0, :pushc, 1, :pushc, 2, :pushl, 3, :fcall, 99, :halt]
    until (@ci.peek == :fcall) do
      @ci.step
    end
    @ci.step

    assert_eq @ci.ctx.stack, ['a', 'b', 'c']
  end
  def test_fcall_sets_returns_to
    @bc.codes = [:pushl, 0, :fcall, 99, :halt]
    @ci = mkci @bc, @ctx
    @ci.step
    @ci.step
    assert_eq @ci.frames.peek.return_to, @bc.codes.index(:halt)
  end
  def test_fcall_actually_jmps_to_beginning_of_function_body
        @bc.codes = [:pushl, 0, :fcall, 99, :halt, :pushl, :xx, :halt]
        floc = @bc.codes.index(:halt) + 1
        @bc.codes[@bc.codes.index(99)] = floc
    @ci = mkci @bc, @ctx
    result = @ci.run
    assert_eq result, :xx
  end

  # test :fret opcode
  def test_fret_pushes_result_on_previous_frame_stack
    # Should use safe_pop method
    @bc, @ctx = compile '1+2'
    @bc.codes.insert(-2, :fret)
    assert_eq @bc.codes[-2..-1], [:fret, :halt]
  end

  # test fre - function returnt
  def test_fret_pops_function_frame_off_stack
    @bc.codes = [:pushl, 99, :halt, :pushl, 200, :fret, :halt]
    @ci = mkci @bc, @ctx
    frame = FunctionFrame.new(Context.new)
    frame.return_to = 0
    @ci.frames.push frame
    @ci.run(3)
    assert_is @ci.last_exception, HaltState
    assert_eq @ci.bc.pc, 3
  end
  def test_fret_pushes_top_of_stack_on_current_restored_stack
    @bc.codes = [:dup, :nop, :halt, :pushl, 200, :fret, :halt]
    @ci = mkci @bc, @ctx
    frame = FunctionFrame.new(Context.new)
    frame.return_to = 0
    @ci.frames.push frame
    result = @ci.run(3)
    assert_eq result, 200
  end

  # test Lambda AST
  def test_ast_emits_calls_for_no_arguments
    parser, transform = parser_transformer
    ir = parser.block.parse '{true}'
    block = transform.apply(ir)
    l = Lambda.subtree([], block)
    @bc, @ctx = emit(loc: 4)
    bc, ctx = emit_walker(block) # function body + :fret
    @bc.codes += [:halt] + bc.codes
    @ci = mkci @bc, @ctx
    @ci.run
  end
  def test_lambda_adds_2_arguments_returns_result
    parser, transform = parser_transformer
ir = parser.block.parse '{ :v1 + :v2 }'
block = transform.apply ir
ast = Lambda.subtree(['v1', 'v2'], block)
ast.first_child.content.value = '_unknown_lambda'
@bc, @ctx = emit(1,2, loc:9)
bc, ctx = emit_walker(ast)
@bc.codes += [:halt] + bc.codes
@ci = mkci @bc, @ctx
assert_eq @ci.run, 3
  end

  # Test :lcall opcode. Combines :bcall and :fcall.
  def test_lcall_sets_redirection_to_lambda_address
    @bc.codes = [:cls, :pushl, 0, :pushv, :bk,   :lcall, :halt, :halt]
    @ctx.vars[:bk] = :Lambda_3
    @ctx.vars[:Lambda_3] = @bc.codes.length - 1
    @ci.run
  end
  # simulate :lcall as if we actually had a way to compile this
  def test_pass_multiple_arguments_to_lambda_and_check_result
    bc, ctx = compile 'lb=->(a, b) { :a + :b };lb(11,44)'
    x= bc.codes.index :icall
    bc.codes[x] = :lcall
    bc.codes[x - 2] = :pushv
    ci = mkci bc, ctx
    assert_eq ci.run, 55
  end
end
