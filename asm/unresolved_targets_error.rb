# unresolved_targets_error.rb - class UnresolvedTargetsError < RuntimeError

# raised if there any targets for jumps with no matching labels
class UnresolvedTargetsError < RuntimeError
  def initialize targets=[]
    super "There are jump targets for which there are no matching labels:#{targets.map(&:inspect).join("\n")}"
  end
end