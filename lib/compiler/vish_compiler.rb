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
    # Remember where the function declarations are
    memoize_functions(ast, functions)

    # Find LogicalAnds, LogicalOrs and properly insert  BranchSource/BranchTarget
    resolve_logical_and(ast)
    resolve_logical_or(ast)

    # resolve Pipe w/any right child nodes that respond_to? :argc
    resolve_pipecalls(ast)


    # Now the funcalls that are actually lambda calls get converted here.
    convert_funcall_to_lambda_call(ast, functions)
    # convert assigned blocks to lambdas w/0 parameters
    convert_assigned_blocks_to_lambdas(ast)
# Convert any block parameters to lambda clalls to lambdas
    convert_block_parameters_to_lambdas(ast, LambdaCall)


    # fixup Return classes

    # Now add back in any previously declared functions passed in here.
    @functions = functions.merge(@functions)

    # Find and process any Lambdas
    @lambdas = extract_lambdas(@ast)

    # fix up any returns within lambdas
    # REMOVEME because there is only one type o return
    #fixup_returns(@lambdas.values.map(&:first), LambdaReturn)

append_lambdas(ast, @lambdas)

# fix up lambda name reference to lambda types into lambda entries
# This is need for some reason ???
    fixup_lambda_entries(@lambdas)

    # add in any passed other lambdas. Possibly from earlier compiles.
    @lambdas.merge!  lambdas
  # replace any Funcall s (:icalls) with FunctionCall s (:fcall)
  # REMOVEME because actual funcalls are now lambda calls, above
#  differentiate_functions(@ast, @functions)
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


  # run - runs all phases of compiler
  # TODO: Add in BulletinBoard.clear to ensure no left dangling JumpTargets
  def run source=@source
    BulletinBoard.clear
    parse source
    transform
    analyze
    generate
  end
end
