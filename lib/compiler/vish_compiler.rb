# vish_compiler.rb - class VishCompiler - handles all phases of compile action

class VishCompiler
  def initialize source=''
    @source = source
  $node_name = 0 # start this from the beginning
    @ast = mknode('root')
    @parser = VishParser.new
    @ir = {}
    @transform = AstTransform.new
    @bc = ByteCodes.new
    @ctx = Context.new
    @blocks = []
  end
  attr_accessor :ast, :parser, :transform, :ir, :ctx, :blocks, :source
  attr_reader :bc

  def parse source=@source
    @ir = @parser.parse source
  end

  def transform ir=@ir
    @ast = @transform.apply ir
  end

  def analyze ast=@ast
    @blocks = extract_assign_blocks(ast)
    # fixup Return classes
    fixup_returns(@blocks, BlockReturn)
    @blocks.each {|b| ast << b }
  end

  def generate ast=@ast
    @bc, @ctx = emit_walker ast, @ctx
  end

  def run source=@source
    parse source
    transform
    analyze
    generate
  end
end
