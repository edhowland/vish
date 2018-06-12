# test_vish.rb - tests for Vish environment stuff, like path resolvers

require_relative 'test_helper'

class TestThing < BaseSpike
  def test_vish_path_is_here_one_up
    assert_eq vish_path, File.expand_path(File.dirname(__FILE__) + '/..')
  end
  def test_vish_path_with_sub_dir
        assert_eq vish_path('bin'), File.expand_path(File.dirname(__FILE__) + '/../bin')

  end
end
