# codes_and_labels.rb - ..method code_and_labels [Opcode, Label, ...]
# returns processed bytescodes and any labels from inpu of AstTransform apply output


def codes_and_labels codes
  flat = codes.map(&:to_a).flatten
  flat.each_with_index {|e, i| e.pc = i if e.kind_of?(Opcode) }
  labels = flat.select {|e| Label === e }
  flat.map! {|e| e.kind_of?(Opcode) ? e.opcode : e }
  targets = flat.select {|e| Target === e }
  return flat, labels, targets
end

def resolve_targets codes, labels, targets
  targets.each do |t|
    t.locate!(labels.find {|l| l == t})
  end
  codes.map {|e| e.instance_of?(Target) ? e.pc : e }
end