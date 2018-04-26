# evaluator.rb - class Evaluator - environment for eval method

class Evaluator
  def initialize
    @compiler = VishCompiler.new
    @saved_heap = {}
    @interpreter = CodeInterpreter.new(ByteCodes.new, Context.new)
  end
  attr_reader :compiler, :saved_heap, :interpreter
  def eval(string, &blk)
    compiler = VishCompiler.new string
    compiler.parse
    compiler.transform
#    compiler.analyze functions:@compiler.functions, blocks:@compiler.blocks, lambdas:@compiler.lambdas
    start = compiler.generate ctx:@compiler.ctx, bcodes:@compiler.bc
    @interpreter = CodeInterpreter.new(compiler.bc, compiler.ctx)
    @interpreter.heap = @saved_heap
    yield @interpreter if block_given?
    @compiler = compiler

    @interpreter.run(start)
  end
end