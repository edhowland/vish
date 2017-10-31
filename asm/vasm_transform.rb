# vasm_transform.rb - class VasmTransform < Parslet::Transform

class VasmTransform < Parslet::Transform
  rule(int: simple(:int)) { mkint(int) }
  rule(clist: sequence(:clist)) { mkconstants(clist) }
  # vars
  rule(ident: simple(:ident), rvalue: simple(:rvalue)) { [ident.to_s, rvalue.to_s] }
  rule(opcode: simple(:opcode), operand: simple(:operand)) { [opcode.to_s.to_sym, operand.to_s] }
#  rule(statement: simple(:statement)) { mkbcode(statement) }
  rule(ctx: simple(:ctx)) { mkcontext(ctx) }
end
