# deref_block.rb - class DerefBlock < Deref - emits code to execute CodeContainer

class DerefBlock < Deref

  # emits the same as parent class: Deref. Then :exec. Which will run it in 
  #  its own context.
  def emit(bc, ctx)
    super
    bc.codes << :exec
  end

  def inspect
    "#{self.class.name}: value: #{@value}"
  end
end