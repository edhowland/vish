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

  def front
    @right = buffer
    @left = []
  end
  def advance
    @left.push(@right.shift)
  end
  def retreat
    @right.unshift(@left.pop)
  end
  def eol
    @left = buffer
    @right = []
  end
  # dispach - handle input
  def dispatch(ch)
    case ch
    # handle left arrow
    when :left
      retreat
      $stdout.print @right[0]
    # handle right arrow
    when :right
      advance
      $stdout.print @right[0]
    # handle Control A
    when "\u0001"
    front
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
    eol
      $stdout.print to_s
    # handle Control L
    when "\f"
      $stdout.print to_s
    # handle CR
    when "\r"
      eol
      push("\n") unless buffer.last == "\n"
      raise StopIteration
    # handle backspace
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

class History
  def initialize
    @lines = []
  end
  attr_accessor :lines
  def start
    @lines << LineBuffer.new
  end
  def dispatch(ch)
    case ch
    when :up
      @lines.rotate!(-1)
      $stdout.print @lines.last.to_s
    when :down
      @lines.rotate!
      $stdout.print @lines.last.to_s
    else
      @lines.last.dispatch(ch)
    end
  end
  def show
    @lines.map(&:to_s)
  end
  def length
    @lines.length
  end
end




# consume - consumes input
# returns actual character or symbol for special charas
# :left, :right, :up, :down
def consume
  ch = $stdin.getch
  if ch == "\u001b"
    sec = $stdin.getch
    third = $stdin.getch
    if sec == "\u005b" && third == "\u0044"
      return :left
    elsif sec == "\u005b" && third == "\u0043"
      return :right
    elsif sec == "\u005b" && third == "\u0041"
#      $stdin.getch
      return :up
    elsif sec == "\u005b" && third == "\u0042"
#      $stdin.getch
      return :down
    end
  end
  return ch
end

# read - reads a line from stdin tty.
# handles backspace, control chars, etc.
# returns complete string input with trailing newline
# Sample usage: read.chomp
def read(history=History.new)
  ch = ''
  history.start
  loop do
    ch = consume
    history.dispatch(ch)
  end
  history.lines.last.to_s
end
