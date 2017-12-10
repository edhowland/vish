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
    @lambdas = []
    @functions = {}
  end
  attr_accessor :ast, :parser, :transform, :ir, :ctx, :blocks, :lambdas, :functions, :source
  attr_reader :bc

  def parse source=@source
    @ir = @parser.parse source
  end

  def transform ir=@ir
    @ast = @transform.apply ir
  end

  def analyze ast=@ast
  @functions = extract_functions(ast)

    @blocks = extract_assign_blocks(ast)
    # fixup Return classes
    fixup_returns(@blocks, BlockReturn)
    @blocks.each {|b| ast << b }

    # add any lambdas back in after blocks (if any)
    @lambdas = extract_lambdas(@ast)

    # fix up any returns within lambdas
    fixup_returns(@lambdas, FunctionReturn)

    @lambdas.each {|l| @ast << l }

  # TODO: MUST: fixup returns for @functions.values
    fixup_returns(@functions.values, FunctionReturn)

    @functions.values.each {|f| ast << f }

  # replace any Funcall s (:icalls) with FunctionCall s (:fcall)
  differentiate_functions(@ast, @functions)
  end

  def generate ast=@ast
    @bc, @ctx = emit_walker ast, @ctx
    @bc.codes.map! {|e|  e.respond_to?(:call) ? e.call : e }
    return @bc, @ctx
  end

  def run source=@source
    parse source
    transform
    analyze
    generate
  end
end
