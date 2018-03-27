# test_list.rb - tests for lists ... Scheme style cons pairs, etc

require_relative 'test_helper'


class TestList < BaseSpike
  include CompileHelper
  def set_up
    @null = Builtins.mknull()
  end
  def test_null_q_is_true
    result = interpret 'l=mknull(); null?(:l)'
    assert result
  end
  def test_array_is_not_a_list
    result = interpret 'l=[];null?(:l)'
    assert_false result
  end
  def test_can_make_null_type
    assert_is @null, NullType
  end

  # cons stuff
  def test_pair_q_is_true_for_pair_literal
    assert interpret('pair?(foo: bar:)')
  end
  def test_pair_q_is_true_for_cons
    assert interpret('pair?(cons(1, 2))')
  end
  def test_pair_q_is_false_for_array
    assert_false interpret('pair?([])')
  end
  def test_pair_q_is_false_for_dict
    assert_false interpret('pair?(~{})')
  end
  def test_pair_q_is_false_for_int
    assert_false interpret('pair?(2)')
  end
  # test list? stuff
  def test_list_q_is_false_for_int
    assert_false interpret('list?(1)')
  end
  def test_list_q_is_false_for_arrary
    assert_false interpret('list?([])')
  end
  def test_list_q_is_false_for_object_dict
    assert_false interpret('o=~{foo: mknull()};list?(:o)')
  end
  def test_cons_is_not_list_wo_null_tail
    result = interpret 'list?(cons(1, 2))'
    assert_false result
  end
  def test_cons_w_null_is_list_true
    assert interpret('list?(cons(1, mknull()))')
  end
  def test_list_q_is_still_true_for_long_list
    assert interpret('list?(cons(1, cons(2, cons(3, cons(4, cons(5, mknull()))))))')
  end
  def test_list_q_is_false_for_long_chain_of_pairs_wo_null_tail
        assert_false interpret('list?(cons(1, cons(2, cons(3, cons(4, cons(5, 5))))))')
  end
end