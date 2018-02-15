# shadow_variables.rb - tests for  ShadowVariables

require_relative 'test_helper'


class TestShadowVariables < BaseSpike
  def set_up
    @sv = ShadowVariables.new
  end
  def test_can_add_and_get_back_one_element
    @sv[:a] = 9
    assert_eq @sv[:a], 9
  end
  def test_value_is_undefined_when_not_present
    result = @sv[:none]
    assert_eq result, Undefined
  end

  # Now test for shadow ability
  def test_can_shadow_variables
    @sv[:a] = 1
    @sv.push
    @sv[:a] = 2
    assert_eq @sv[:a], 2
  end
  def test_after_push_assign_then_pop_original_value_is_preserved
    value = 5
    @sv[:a] = value
    @sv.push
    @sv[:a] = 9
    @sv.pop
    assert_eq @sv[:a], value
  end

  # test pass-thru for variables not at the top
  def test_can_access_variables_through_pass_thru
    @sv[:a] =9
    @sv.push
    @sv[:b] = 3
    assert_eq @sv[:a], 9
  end
end