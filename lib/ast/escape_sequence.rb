# escape_sequence.rb - class EscapeSequence < Terminal - strings like \n, \t, \\

class EscapeSequence < Terminal
  def initialize escape_seq
    @value = escape_seq.to_s
  end
end