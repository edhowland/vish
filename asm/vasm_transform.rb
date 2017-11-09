# vasm_transform.rb - class VasmTransform < Parslet::Transform

class VasmTransform < Parslet::Transform
  rule(int: simple(:int)) { mkint(int) }

  rule(clist: simple(:clist)) { clist.nil? ? [] : [clist] }
  rule(clist: sequence(:clist)) { mkconstants(clist) }
  # vars
  rule(ident: simple(:ident), rvalue: simple(:rvalue)) { [ident.to_s, rvalue.to_s] }

  rule(label: simple(:label), opcode: simple(:opcode), operand: simple(:operand)) { Label.new(label, opcode, Operand.new(operand)) }
  rule(label: simple(:label), opcode: simple(:opcode), target: simple(:target)) { LabeledJump.new(label, opcode, target) }
  rule(label: simple(:label), opcode: simple(:opcode)) { Label.new(label, opcode) }

  rule(opcode: simple(:opcode), operand: simple(:operand)) { Opcode.new(opcode, Operand.new(operand)) }
    rule(opcode: simple(:opcode), target: simple(:target)) { Jump.new(opcode, target) }
  rule(opcode: simple(:opcode)) { Opcode.new(opcode) }

#  rule(statement: simple(:statement)) { mkbcode(statement) }
  rule(ctx: simple(:ctx)) { mkcontext(ctx) }
end
