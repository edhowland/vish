# jump_target.rb - class JumpTarget - holder for actual and possible jump
# targets

# A JumpTarget is either created or searched for in BulletinBoard during code
# emission phase. This is because it may be a jump forward before it is known.
# or it may jump back if has been already seen.
#
# An example:
# ```
# foo(1)
# x=9
# defn foo(a) { :a + 11 }
#```
# 
# A single pass compiler, while faster forces all jump targets to be known
# ahead of time. A Dual pass compiler can store abstract references to virtual
#  jump targets and then resolve them during the second pass.
#
# 
UNKNOWN_TARGET = -1
class JumpTarget
  def initialize name
    @name = name.to_sym
    @target = UNKNOWN_TARGET
    @reference_count = 0
  end
  attr_reader :name, :reference_count
  attr_accessor :target
end
