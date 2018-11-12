# test_helper.rb - Wires ./lib to ../vish.rb and friends

require_relative '../lib/vish'

require_relative 'lib/spike_load'

module CompileHelper
  # Use in set_up:
  def parser_transformer
    return VishParser.new, SexpTransform.new
  end
  def standard_lib
    File.read('std/lib.vs')
  end
  def compile string
  # @compiler = VishCompiler.new string
  @compiler ||= VishCompiler.new('')
  @compiler.source = string
  @compiler.run
  return @compiler.bc, @compiler.ctx
  end
  def mkci bc, ctx
    CodeInterpreter.new(bc, ctx)
  end
  def interpret(string)
    bc, ctx = compile string
    ci = mkci bc, ctx
    ci.run
  end  
    # TODO: Check if can remove this method:
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