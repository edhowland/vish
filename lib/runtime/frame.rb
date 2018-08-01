# frame.rb - class  MainFrame, FunctionFrame

class MainFrame
  def initialize ctx
    @ctx = ctx
    @return_to = -1
  end
  attr_accessor :ctx, :return_to
  def _clone
    result = self.class.new Builtins.clone(@ctx)
    result.return_to = @return_to
    result
  end
end

class FunctionFrame < MainFrame
  def initialize ctx
    @ctx = ctx
  end
end
