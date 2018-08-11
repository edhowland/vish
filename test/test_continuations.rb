# test_continuations.rb - tests for

require_relative 'test_helper'

class TestContinuations < BaseSpike
#  include WithStdLib
include CompileHelper
def set_up
  @stdlib = File.read(stdlib()) + "\n"
end
  def test_generator
    src = <<-EOD
    kk=9
   defn gen() {
  x=0
init=false
loop {
  callcc(->(k) {kk=:k})
! :init && return {init=true}
  x=:x + 1
return :x
  }
}
%gen
%kk
#%kk
EOD
    x = interpret @stdlib + src

  end

end