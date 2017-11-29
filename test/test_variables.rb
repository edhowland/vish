# test_variables.rb - tests for things with variables

require_relative 'test_helper'

class TestVariables < BaseSpike
  include CompileHelper

  def test_can_set_and_retrieve_variable_value
    assert_eq interpertit('var=5*5;:var'),  25
  end
  def test_can_set_variable_and_then_set_it_to_its_value_again
    assert_eq interpertit( 'name=0;name=:name+1;name=1+:name;:name'), 2
  end
end