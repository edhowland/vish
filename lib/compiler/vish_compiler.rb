# vish_compiler.rb - class VishCompiler - handles all phases of compile action

class VishCompiler
  def initialize source=''
    @source = source
#  $node_name = 0 # start this from the beginning
#    @ast = mknode('root')
@ast = NullType.new
    @parser = VishParser.new
    @ir = {}
    @transform = SexpTransform.new  #AstTransform.new
    @generator = Semit.new
    @bc = ByteCodes.new
    @ctx = Context.new
    @blocks = []
    @lambdas = {}
    @functions = {}
  end
  attr_accessor :ast, :parser, :transform, :generator, :ir, :ctx, :blocks, :lambdas, :functions, :source
  attr_reader :bc

  def parse source=@source
    @ir = @parser.parse source
  end

  def transform ir=@ir
    @ast = @transform.apply ir
  end

  def analyze ast=@ast, functions:@functions, blocks:@blocks, lambdas:@lambdas
    # NOP # for now, at least
  end

  def generate ast=@ast, ctx:@ctx, bcodes:@bc
    start = bcodes.codes.length

    codes = @generator.emit(ast)
    bcodes.codes = codes
    @bc = bcodes

start
  end


  # run - runs all phases of compiler
  def run source=@source
    parse source
    transform
    analyze
    generate
  end
end
