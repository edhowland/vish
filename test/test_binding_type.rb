# test_binding_type.rb - tests for BindingType

require_relative 'test_helper'

class TestBindingType < BaseSpike
  def set_up
    @b = BindingType.new
  end
  def test_is_at_root
    assert @b.root?
  end
  def test_is_not_root_after_setting_binding
    @b.set :a, 9
    assert_false @b.root?
  end
  # Test can set a binding
  def test_can_set_a_binding
    @b.set :a, 9
  end
  def test_can_set_binding_and_get_it_back
    @b.set(:a, 9)
    assert_eq @b.get(:a), 9
  end
  def test_can_set_a_different_binding_w_value
    @b.set(:a, 3)
    assert_eq @b.get(:a), 3
  end
  # Now set more than one binding
  def test_can_set_more_than_one_binding
    @b.set(:a, 9)
    @b.set(:b, 3)
    assert_eq @b.get(:a), 9
  end
  # test out of order queries
  def test_can_set_3_values_and_get_out_of_order_1
    @b.set :a, 1
    @b.set :b, 2
    @b.set :c, 3
    assert_eq [@b.get(:b), @b.get(:c), @b.get(:a)], [2, 3, 1]
  end
  def test_can_set_4_bindings_and_get_in_reverse_order
    @b.set :a, 'a'
    @b.set :b, 'b'
    @b.set :c, 'c'
    @b.set :d, 'd'
    assert_eq [:d, :c, :b, :a].map {|b| @b.get(b) }.join, 'dcba'
  end
  def test_at_root_no_binding_is_defined
    assert_false(@b.set?(:a))
  end
  def test_after_set_still_undefined
    @b.set :a, 4
    assert_false @b.set?(:c)
  end

  # Now test out dup method
  def test_can_dup_and_still_get_stored_binding
    @b.set :a, 4
    b2 = @b.dup
    assert_eq b2.get(:a), 4
  end
  def test_variable_shadows_same_name_in_original_binding
    @b.set :a, 9
    b2 = @b.dup
    b2.set :a, 3
    assert_eq b2.get(:a), 3
    assert_eq @b.get(:a), 9
  end

  # Now test for set!, after testing find_pair :key
  def test_can_find_pair
    @b.set(:a, 9)
    x = @b.find_pair :a
    assert_is x, PairType
  end
  def test_can_get_actual_pair_for_key
    @b.set(:a, 9)
    @b.set(:b, 3)
    x = @b.find_pair :a
    assert_eq x.key, :a
    assert_eq x.value, 9
  end

  # Now test set!
  def test_set_question_returns_true
    @b.set :a, 4
    assert @b.set? :a
  end
  def test_set_bang_raises_attempt_to_set_undefined_binding
    assert_raises AssignmentDisallowed do
      @b.set! :a, 3
    end
  end
  def test_can_set_bang_existing_variable
    @b.set(:a, 9)
    @b.set!(:a, 3)
    assert_eq @b.get(:a), 3
  end
end