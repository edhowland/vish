# escape_sequence.rb - class EscapeSequence < Terminal - strings like \n, \t, \\

class EscapeSequence < Terminal
  def initialize escape_seq
    @value = escape_seq.to_s
  end

  # :to_s, converts actual sequence into real character - cheat and just ruby's
  # eval method
  def to_s
    eval('"' + @value.to_s + '"')
  end
end