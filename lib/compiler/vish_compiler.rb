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
    # Optimizeation parameters
    @optimizers = {
      identity_optimizer: IdentityOptimizer,
      constant_folder: ConstantFolder,
      tail_call: TailCall
    }
    # Default optimizers actually turned.
    # Must at least have IdentityOptimizer :identity_optimizer
    @default_optimizers = {
           identity_optimizer: true,
      constant_folder: false,
      tail_call: false 
    }
  end
  attr_accessor :ast, :parser, :transform, :generator, :ir, :ctx, :blocks, :lambdas, :functions, :source, :default_optimizers, :optimizers
  attr_reader :bc

  def parse source=@source
    @ir = @parser.parse source
  end

  def transform ir=@ir
    @ast = @transform.apply ir
  end

  # Optimize Phase
  def optimize(ast)
    # run thru currently set optimizers
    @optimizers.to_a.select {|k, v| @default_optimizers[k] }.map {|k, v| v }.reduce(ast) {|tree, klass| klass.new.run(tree) }
  end

  # Analysis Phase
  def analyze ast=@ast, functions:@functions, blocks:@blocks, lambdas:@lambdas
    @ast=optimize(ast)
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
