# resolve_lambda_locations.rb - method resolve_lambda_locations(bytecodes)
# puts the :lcall jump targets in places where LambdaName emitted code

# fixup_jump_targets(bc) - gets any dangling targets from BulletinBoard
def fixup_jump_targets(bc)
  bc.codes.each do |c|
    if c.class == JumpTarget
      jt = BulletinBoard.get(c.name)
      c.target = jt.target
    end
  end
end

def resolve_lambda_locations(bc)
  fixup_jump_targets(bc)

  bc.codes.each_with_index do |e, i|
    if e.kind_of?(JumpTarget)
      bc.codes[i] = e.target
    end
  end
end
