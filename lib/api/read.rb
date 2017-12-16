# read.rb - read a line of input in raw mode

require 'io/console'


# LineBuffer - handles storage of line contents, keyboard interaction
class LineBuffer
  def initialize string=''
    @buffer = string.chars
  end
  attr_accessor :buffer
  def pop
    @buffer.pop
  end
  def push(ch)
    @buffer.push(ch)
  end
  alias_method :<<, :push
  def to_s
    @buffer.join
  end
  def length
    @buffer.length
  end

  # dispach - handle input
  def dispatch(ch)
    case ch
    when "\r"
      @buffer.push("\n")
    when "\u007f"
      drop = @buffer.pop
      drop = 'space' if drop == ' '
      $stdout.print "delete #{drop}"
    else
      @buffer.push(ch)
      $stdout.print ch
    end
  end
end

# TODO REMOVEME
def handle_ch(buffer, ch)
  # handle CR : translate to NL
  if ch == "\r"
    buffer << "\n"
  # handle backspace
  elsif ch == "\u007f"
    drop = buffer[-1]
    drop = 'space' if drop == ' '
    buffer = buffer[0..-2]
    $stdout.print "delete #{drop}"
  else
    buffer << ch
  end
end

# read - reads a line from stdin tty.
# handles backspace, control chars, etc.
# returns complete string input with trailing newline
# Sample usage: read.chomp
def read
  buffer =LineBuffer.new
  ch = ''
  while ch != "\r"
    ch = $stdin.getch
    buffer.dispatch(ch)
  end
  buffer.to_s
end
