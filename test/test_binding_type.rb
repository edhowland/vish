# test_binding_type.rb - tests for BindingType

require_relative 'test_helper'

class TestBindingType < BaseSpike
  include CompileHelper
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
  def test_is_empty
    assert @b.empty?
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

  # Now pretend we are Hash/Dictionary
  def test_can_use_bracket_get
    @b.set :a, 66
    assert_eq @b[:a], 66
  end
  def test_can_assign_w_brackets
    @b[:a] = 55
    assert_eq @b[:a], 55
  end
  def test_reassigns_same_value
    @b.set :c, 'c'
    pair = @b.find_pair :c
    @b[:c] = 67
    assert_eq pair.value, 67
  end

  # test walking the nodes
  def test_can_walk_empty_list
    x=0
    @b.walk {|pt| x += 1 }
    assert_eq x, 0
  end
  def test_walks_1_node
    x = 0
    @b[:a] = 9
    @b.walk {|pt| x += 1 }
    assert_eq x, 1
  end
  def test_walk_can_compute_length_of_members
    x = 0
    @b[:a] = 1
    @b[:b] =2
    @b[:c] = 3
    @b[:d] =4
    @b.walk {|pt| x += 1}
    assert_eq x, 4
  end
  # test aggregate methods
  def test_variables_when_empty
    #
  end
  def test_pair_type_is_yielded_to_block
    @b[:a] = 9
    @b.walk do |pt|
      assert_is pt, PairType
    end
  end
  def test_variables_when_2_variables
    @b[:a] = 1
    @b[:b] = 2
    assert_eq @b.variables, [[:b, 2], [:a, 1]]
  end

  # test for stack overflow ... in Ruby
  def test_binding_assignment_does_cause_ruby_stack_overflow
    interpret 'b=binding();:b'
  end
  def test_length_is_0
    assert @b.length.zero?
  end
  def test_length_is_1
    @b[:a] = 9
    assert_eq @b.length, 1
  end
  def test_length_is_4
    @b[:a]=0
    @b[:b]=1
    @b[:c]=2
    @b[:d]=3
    assert_eq @b.length, 4
  end
end