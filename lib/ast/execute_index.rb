# execute_index.rb - class ExecuteIndex < Terminal
# represents calls like: %m[0], %m[foo:], %m[:index]. The  indexed node is
# expected to be a lambda reference 


class ExecuteIndex < ListIndex
  def initialize deref, index
    super
    @argc = 0
  end
  attr_accessor :argc
  def emit(bc, ctx)
        # Get the item off the heap and push on stack
    super
    bc.codes << :pushc
    bc.codes << ctx.store_constant(@argc)    # now setup the call for the :lcall
    bc.codes << :swp
    bc.codes << :pusha

    bc.codes << :lcall
  end

  def inspect
    super + " argc: #{@argc}"
  end
end