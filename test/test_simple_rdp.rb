# test_simple_rdp.rb - tests for  SimpleRDP

require_relative 'test_helper'

class TestSimpleRDP < BaseSpike
  def set_up
    @rdp = SimpleRDP.new(term_p: ->(v) { Numeral.new(v) }, nont_p: ->(o, l, r) { [o, l, r] })
  end
  def test_init
    @rdp.tokens = [0,:+, 1]
  end
  def test_fetch_gets_next_token
    @rdp.tokens = [0,:+, 1]
    result = @rdp.fetch
    assert_eq result, 0
  end
  def test_decode_returns_next_state_w_non_plus_element
        @rdp.tokens = [0,:+, 1]
    assert_eq @rdp.decode(@rdp.fetch), :terminal
  end
  def test_empty_tokens_cause_execute_to_go_to_fin_state_raising_stop_iteration
    assert_raises StopIteration do
    result = @rdp.execute :fin
    end
  end
  def test_terminal_returns_numeral
    @rdp.tokens = [1]
    tok = @rdp.fetch
    state = @rdp.decode tok
    result = @rdp.execute state, tok
    assert_is result, Numeral
  end
  def test_step_accumulates_result
    @rdp.tokens = [1, :+, 2]
    @rdp.step
    assert_is @rdp.acc, Array
    assert_eq @rdp.acc.length, 2
  end
  def test_step_runs_to_fin_state
    assert_raises StopIteration do
      @rdp.step
    end
  end
  def test_run_returns_at_empty_input
    @rdp.run
    assert_eq @rdp.acc, [nil]
  end
  def test_state_is_preserved
    @rdp.tokens = [1]
    @rdp.step
    assert_eq @rdp.state, :terminal
  end
  def test_expect_terminal_works
  @rdp.tokens = [1]
    @rdp.expect(:terminal)
    assert_is @rdp.last, Numeral
  end
  def test_expect_raises_rdp_syntax_error_when_non_expanct_thing
    assert_raises SimpleRDP::SyntaxError do
      @rdp.expect(:terminal)
    end
  end
  def test_non_terminal_accumulates_sexp_postfix_add_left_right
    @rdp.tokens = [1, :+, 2]
    @rdp.run
    result = @rdp.last
    assert_eq result[0], :+
    assert_eq result[1].value, 1
    assert_eq result[2].value, 2
  end
  def test_raises_syntax_error_when_missing_terminal
    @rdp.tokens = [1, :+]
    assert_raises SimpleRDP::SyntaxError do
      @rdp.run
    end
  end
  def test_multi_returns_many_adds_in_tree
    rdp = SimpleRDP.new array_join([1,2,3,4,5,6], :+)
    rdp.run
    assert_eq rdp.last, [:+, [:+, [:+, [:+, [:+, 1 ,2], 3], 4], 5], 6]
  end
  def test_empty_input_is_just_nil
    rdp=SimpleRDP.new
    rdp.run
    assert_nil rdp.last
  end
  def test_single_terminal_is_returned_in_last
    rdp=SimpleRDP.new ["hello"]
    rdp.run
    assert_eq rdp.last, "hello"
  end
  def test_allows_default_when_empty_input
    rdp=SimpleRDP.new default:''
    rdp.run
    assert_eq rdp.last, ''
  end
end
