# utilities.rb - methods: mkconstants, ...

require_relative '../lib/vish'


def mkcontext ctx
  c = Context.new
  c.constants = ctx[:constants][:clist]
  c
end

def mkconstants(clist)
  clist
end

def mkint value
  value.to_i
end
def mkbcode(stmnt)
  opcode = stmnt[:opcode].to_s.to_sym
  oper = stmnt[:operand]
  result = [opcode]
  result << oper.to_s unless oper.nil?
  result
  
end