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
    @lambdas = {}
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

  def analyze ast=@ast, functions:@functions, blocks:@blocks, lambdas:@lambdas
    # Find LogicalAnds, LogicalOrs and properly insert  BranchSource/BranchTarget
    resolve_logical_and(ast)
    resolve_logical_or(ast)

    # resolve Pipe w/any right child nodes that respond_to? :argc
    resolve_pipecalls(ast)

    # locate and extract any defn function declarations. Move to @functions hash
  @functions = extract_functions(ast)

    # convert assigned blocks to lambdas w/0 parameters
    convert_assigned_blocks_to_lambdas(ast)
    # convert any function call parameters that are blocks to lambdas
    convert_block_parameters_to_lambdas(ast, Funcall)
# Convert any block parameters to lambda clalls to lambdas
    convert_block_parameters_to_lambdas(ast, LambdaCall)


    # fixup Return classes
    # fixup_returns(@blocks, BlockReturn)
    # @blocks.each {|b| ast << b }
    # Now add back in any previously declared blocks
    # @blocks = blocks + @blocks

    fixup_returns(@functions.values, FunctionReturn)
    # Append the actual function bodies to end of AST
    @functions.values.each {|f| ast << f }
    # Now add back in any previously declared functions passed in here.
    @functions = functions.merge(@functions)

    # Find and process any Lambdas
    @lambdas = extract_lambdas(@ast)

    # fix up any returns within lambdas
    fixup_returns(@lambdas.values.map(&:first), LambdaReturn)

#    @lambdas.each {|l| @ast << l }
append_lambdas(ast, @lambdas)

# fix up lambda name reference to lambda types into lambda entries
fixup_lambda_entries(@lambdas)

    # add in any passed other lambdas. Possibly from earlier compiles.
    @lambdas.merge!  lambdas
  # replace any Funcall s (:icalls) with FunctionCall s (:fcall)
  differentiate_functions(@ast, @functions)
  end

  def generate ast=@ast, ctx:@ctx, bcodes:@bc
    start = bcodes.codes.length

    @bc, @ctx = emit_walker ast, ctx, bcodes

    # Resolve BranchSource operands after BranchTargets have been emitted
    visit_ast(ast, BranchSource) do |n|
      bc.codes[n.content.operand] = find_ast_node(ast, bc.codes[n.content.operand]).content.target
    end
    @bc.codes.map! {|e|  e.respond_to?(:call) ? e.call : e }

    # resolve jump targets
    resolve_lambda_locations(@bc)

start
  end

  # check if any errors or deprecations exist or any other warnings
  def check
    deprecation_functions(@ast)
  end

  def run source=@source
    parse source
    transform
    analyze
    generate
  end
end
