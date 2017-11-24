# vish_compiler.rb - class VishCompiler - handles all phases of compile action


class VishCompiler
  def initialize source=''
    @source = source
    @ast = mknode('root')
    @parser = VishParser.new
    @ir = {}
    @transform = AstTransform.new
    @bc = ByteCodes.new
    @ctx = Context.new
  end
  attr_accessor :ast, :parser, :transform, :ir
  attr_reader :bc, :ctx

  def parse string
    @ir = @parser.parse string
  end

  def transform ir=@ir
    @ast = @transform.apply ir
  end

  def generate ast=@ast
    @bc, @ctx = emit_walker ast
  end

  def run source=@source
    parse source
    transform
    generate
  end
end
