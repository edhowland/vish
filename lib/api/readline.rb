# readline.rb - read a line of input in raw mode
# Handle everything, including control chars.
# Control A - Move to beginning of line
# Control - C Clear line and raise SigInt exception
# Control D - Raise EOF if line is empty, else beep bell
# Control E - Move to end of line
# Control L - echo contents of line
#
# Cursor movement
# Maintains line history if passed in extermal History instance.
# Otherwise, only a single line is edited.
# Left - Moves the cursor one character to the left.
# Right - Moves the cursor one character to right 
# The above actions will beep if the end of their respective detants.
# History
# Up - Moves one line back in the history.
# Down - Moves one line forward in the history.
# The above actions will rotate the history buffer if reached some detent.
# TODO: Provide a way to save and restore history.

require 'io/console'

class SigInt < RuntimeError; end
class EndOfFile < RuntimeError; end

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
  if @right.empty?
    bell
    return
  end
    @left.push(@right.shift)
  end
  def retreat
  if @left.empty?
    bell
    return
  end
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
    when "\u0003"
      @left.clear
      @right.clear
      raise SigInt
    # handle Control D
    when "\u0004"
      if buffer.empty?
        raise EndOfFile
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

# TODO: Should not really rotate the @lines buffers.
# There should be some kind of position. Do a Bell when reached of list at eithere end
# History - maintian list of LineBuffer s.
# Handle up/down arrows
# otherwise pass delegation through to current LineBuffer.
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
      @lines.last.eol
      $stdout.print @lines.last.to_s
      @lines.last.retreat if @lines.last.buffer.last == "\n"
    when :down
      @lines.rotate!
      @lines.last.eol
      @lines.last.retreat if @lines.last.buffer.last == "\n"
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
def readline(history=History.new)
  ch = ''
  history.start
  loop do
    ch = consume
    history.dispatch(ch)
  end
  history.lines.last.to_s
end
