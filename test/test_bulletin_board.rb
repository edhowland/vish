#  tests for BulletinBoard and JumpTarget

 require_relative 'test_helper'


class TestBulletinBoard  < BaseSpike
  include CompileHelper
  def set_up
    BulletinBoard.clear
  end
  def test_create_a_jump_target_and_store_in_bb
    jt = JumpTarget.new 'xxyyzz'
    BulletinBoard.post jt
    result = BulletinBoard.get jt.name
    assert_eq result, jt
  end
  def test_put_adds_it_if_it_does_not_exist
    name = 'wysiswyget'
    jt = JumpTarget.new name 
    BulletinBoard.post jt
    result = BulletinBoard.get  name
    assert_eq result, jt
  end
  def test_put_is_idempotent
    name = 'jp1'
    jt = JumpTarget.new name
    BulletinBoard.post jt
    jt2 = JumpTarget.new name
    BulletinBoard.post jt2
    assert BulletinBoard.get(name), jt
  end
end
