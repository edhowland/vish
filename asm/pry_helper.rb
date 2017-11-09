# pry_helper.rb - pry helps for vish/asm dir

require_relative '../runtime/load_codes'

require_relative 'vasm_requires'


require_relative 'vasm_grammar'
require_relative 'utilities'
require_relative 'vasm_transform'
require_relative 'codes_and_labels'

# vdis stuff
require_relative 'dis_requires'

# pry helper requires
require_relative '../pry/lib'


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


def ex fname
  s, l = rfile fname
  p = pars
  p.parse s
end

def cfile fname
  f = File.open(fname, 'r')
  load_codes f
end
def vasm
  return VasmGrammar.new, VasmTransform.new
end
def assemble fname
  p, a = vasm
  s,l = rfile fname
  ir = p.parse s
  a.apply ir
end

# pa: return VasmGrammer.new, VasmTransform.new
# Usage: p, a = pa;
def pa
  return  VasmGrammar.new, VasmTransform.new
end

# misty: play misty for me: runs one step
# + ci : The CodeInterperter
def misty ci, &blk
  begin
  print 'stack: '; p ci.ctx.stack
  puts 'vars: '; p ci.ctx.vars
  print 'next instruction: '; p ci.peek
  gets
  ci.step
  rescue HaltState
    puts 'halted'
  rescue OpcodeError => err
    puts err.message
  end
end


# nci : Makes a new ci from bc, ctx
# Parameters:
# + bc: ByteCodes
# + ctx : Context
def nci bc, ctx
  CodeInterperter.new bc, ctx
end

