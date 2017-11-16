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
    ir = @parser.parse string
    ast = @transform.apply ir
    emit_walker ast
  end
  def mkci bc, ctx
    CodeInterperter.new(bc, ctx) {|_bc, _ctx, bcodes| bcodes[:print] = ->(bc, ctx) { @result = ctx.stack.pop } }
  end
  def interpertit string
    bc, ctx = compile string
    ci = mkci bc, ctx
    ci.run
  end  
end