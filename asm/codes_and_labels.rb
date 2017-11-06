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
  # check first if we have any duplicate labels
  check_for_duplicate labels
  # check targets to see if they can find any matching labels
  targets.each do |t|
    t.locate!(labels.find {|l| l == t})
  end
  # see if any labels remain unfriended
  labels.each {|l| targets.each {|t| l.friend_me(t) } }
  codes.map {|e| e.instance_of?(Target) ? e.pc : e }
end


# check for duplicate labels
def check_for_duplicate labels
  h = labels.each_with_object({}) {|e, o| o[e.name] = 0 }
  labels.each {|l| h[l.name] += 1 }
  if h.any? {|k,v| v > 1 }
    h.reject! {|k,v| v == 1}
    raise DuplicateLabelsError.new labels.reject {|l| h[l.name].nil? }
  end
end