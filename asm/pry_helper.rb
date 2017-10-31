# pry_helper.rb - pry helps for vish/asm dir

require_relative 'vasm_grammar'

def rfile fname
  s = File.read(fname)
  return s, s.lines
end

def pars
  VasmGrammar.new
end

# run { p.constants.parse 'ctx' }
def run &blk
  begin
    yield
  rescue Parslet::ParseFailed => failure
    puts failure.parse_failure_cause.ascii_tree 
  end
end
