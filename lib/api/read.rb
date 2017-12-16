# read.rb - read a line of input in raw mode

require 'io/console'


def bell
  $stdout.print 7.chr
end

# LineBuffer - handles storage of line contents, keyboard interaction
class LineBuffer
  def initialize string=''
    @left = string.chars
    @right = []
  end
  def buffer
    @left + @right
  end
  def pop
    @left.pop
  end
  def push(ch)
    @left.push(ch)
  end
  alias_method :<<, :push
  def to_s
    buffer.join
  end
  def length
    buffer.length
  end

  # dispach - handle input
  def dispatch(ch)
    case ch
    # handle Control A
    when "\u0001"
      @right = buffer
      @left = []
      $stdout.print to_s
    # handle Control C
    # TODO: Must actually terminate repl iteration, and skip to nextinput
    when "\u0003"
      @left.clear
      @right.clear
      raise StopIteration
    # handle Control D
    # TODO: This must do a EOF and return from REPL
    when "\u0004"
      if buffer.empty?
        raise StopIteration
      else
        bell
      end
    # handle Control E
    when "\u0005"
      @left = buffer
      @right = []
      $stdout.print to_s
    # handle Control L
    when "\f"
      $stdout.print to_s
    when "\r"
      push("\n")
      raise StopIteration
    when "\u007f"
      drop = pop
      drop = 'space' if drop == ' '
      $stdout.print "delete #{drop}"
    else
      push(ch)
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
  loop do
    ch = $stdin.getch
    buffer.dispatch(ch)
  end
  buffer.to_s
end
