# evaluator.rb - class Evaluator - environment for eval method

class Evaluator
  def initialize
    @compiler = VishCompiler.new
  end
  attr_reader :compiler
  def eval(string)
    compiler = VishCompiler.new string
    compiler.parse
    compiler.transform
    compiler.analyze functions:@compiler.functions, blocks:@compiler.blocks, lambdas:@compiler.lambdas
    start = compiler.generate ctx:@compiler.ctx, bcodes:@compiler.bc
    interpreter = CodeInterpreter.new(compiler.bc, compiler.ctx)
    @compiler = compiler
    interpreter.run(start)
  end
end