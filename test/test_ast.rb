# test_ast.rb - tests for lib/ast folder

require_relative 'test_helper'

class TestAst < BaseSpike
  def set_up
    @ctx = Context.new
    @bc = ByteCodes.new
  end
  def test_boolean_is_true_class
    assert_eq Boolean.new('true').value.class, TrueClass
  end
  def test_boolean_w_false_becomes_false_class
    assert_eq Boolean.new('false').value.class, FalseClass
  end
  def test_boolean_raises_unknown_error_w_given_unrecognized_inpu    #
  end
    assert_raises RuntimeError do
      Boolean.new 'xxyzzy'
    end

  # Test emit
  def test_emits_correct_ruby_literal_value_for_true_w_true_class
    b = Boolean.new 'true'
    b.emit(@bc, @ctx)
  assert @ctx.constants[0]
    assert_eq @bc.codes, [:pushc, 0]
  end
  def test_boolean_emits_false_w_given_false_string
     b = Boolean.new('false')
    b.emit(@bc, @ctx)
    assert_false @ctx.constants[0]
    assert_eq @bc.codes, [:pushc, 0]
  end
end