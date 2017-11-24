# break_point_reached.rb - class BreakPointReached < RuntimeErrror - Used in debugging

class BreakPointReached < RuntimeError
  def initialize
    super 'Break point reached!'#
  end
end
