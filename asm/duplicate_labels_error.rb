# duplicate_labels_error.rb - class DuplicateLabels_error < RuntimeError
# raised if we detected any duplicate labels


class DuplicateLabelsError < RuntimeError
  def initialize labels
    super "Ooops: We detected some duplicate labels in your code. Here they are\n" + labels.map(&:inspect).join("\n")
  end
end