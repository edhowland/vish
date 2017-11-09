# unknown_target.rb - class UnknownTarget < Target - Used in vdis.rb to capture
# known locations:(pc) but undefined labels. 

class UnknownTarget < Target
  def initialize pc
    @pc = pc
    @name = "lbl#{'%05d' % @pc}"
  end
end
