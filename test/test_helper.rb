# test_helper.rb - Wires ./lib to ../vish.rb and friends

require_relative '../lib/vish'

require_relative 'lib/spike_load'

module CompileHelper
  # Use in set_up:
  # @parser, @transform = parser_transformer
  def parser_transformer
    return VishParser.new, AstTransform.new
  end
  def compile string
  @compiler = VishCompiler.new string
  @compiler.run
  return @compiler.bc, @compiler.ctx
  end
  def mkci bc, ctx
    CodeInterpreter.new(bc, ctx)
  end
  def interpertit string
    bc, ctx = compile string
    ci = mkci bc, ctx
    ci.run
  end  

def mk_ast string
  @transform.apply(@parser.parse(string))
end
end

module InterpreterHelper
  def set_up
        @bc = ByteCodes.new
    @ctx = Context.new
    @result = nil
    @ci = CodeInterpreter.new @bc, @ctx
  end
end