# test_builtins.rb - tests for builtin methods

require_relative 'test_helper'

class TestBuiltins < BaseSpike
  include CompileHelper
  def set_up
    @lib = standard_lib
  end
  def test_unknown_fn_call_raises_lambda_not_found
    assert_raises LambdaNotFound do
      interpret 'foo()'
    end
  end

  # builtin predicates
  def test_atom_w_int
    assert interpret('atom?(1)')
  end
  def test_atom_w_symbol
    assert interpret('atom?(foo:)')
  end
  def test_atom_w_true
    assert interpret('atom?(true)')
  end
  def test_atom_w_false_is_still_true
    assert interpret('atom?(false)')
  end
  def test_non_atom_w_null
    assert_false interpret(@lib + ';atom?(:null)')
  end
  def test_non_atom_w_pair
    assert interpret('! atom?(bax: 33)')
  end
  def test_atom_w_string
    assert interpret('!atom?("")')
  end
  def test_atom_true_is_true
    assert interpret('atom?(true)')
  end
  def test_atom_w_false_is_true
    assert interpret('atom?(false)')
  end
  def test_non_atom_for_any_list_including_null
    assert_false interpret(@lib + ';atom?(:null)')
  end
  def test_non_atom_for_list_of_2_elements
    assert interpret('!atom?(list(1,2))')
  end
  def test_non_atom_for_string
    assert_false interpret('atom?("")')
  end
  def test_non_atom_for_vector_of_1_element
    assert interpret('! atom?([1])')
  end
  def test_non_atom_w_object
    assert_false interpret('atom?(~{})')
  end
  # empty
  def test_empty_w_string
    assert interpret('empty?("")')
  end
  def test_empty_w_array
    assert interpret('empty?([])')
  end
  def test_empty_w_object
    assert interpret('empty?(~{})')
  end
  def test_empty_w_list
    assert interpret('empty?(list())')
  end
  def test_non_empty_w_int
    assert_false interpret('empty?(1)')
  end
  def test_non_empty_w_string_of_1_char
    assert_false interpret('empty?("a")')
  end
  def test_non_empty_w_negation_w_list_of_1_element
    assert interpret('! empty?(list(1))')
  end
  def test_non_empty_w_pair_type
    assert_false interpret('empty?(foo: 1)')
  end
  def test_non_empty_w_negation_w_vector_of_many_elements
    assert interpret('! empty?([0,1,2,3,4])')
  end
  def test_non_empty_w_object_with_2_key_value_pairs
    assert_false interpret('empty?(~{foo: bar:, baz: 44})')
  end
  # head/tail of vectors
  def test_head
    assert_eq interpret('head([0,1,2,3])'), 0
  end
  def test_tail
    assert_eq interpret('tail([0,1,2,3])'), [1,2,3]
  end
end