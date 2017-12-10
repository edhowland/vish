# close.rb - closure over instance var in class

class Clo
  def initialize v
    @v = v
  end
  attr_accessor :v
  def cl
    ->() { @v }
  end
end