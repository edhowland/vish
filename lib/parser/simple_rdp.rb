# simple_rdp.rb - class SimpleRDP - simple recursive descent parser

class SimpleRDP
  class SyntaxError < RuntimeError
    def initialize
      super 'Ooops! Got syntax error on current token'#
    end
  end
  def initialize array=[], default:nil, term_p: ->(v) { v }, nont_p: ->(o, l, r) { [o, l, r] }
    @tokens = array
    @acc = [default]
    @state = :start
    @term_p = term_p
    @nont_p = nont_p
  end
  attr_reader :acc, :state
  attr_accessor :tokens

  def last
    @acc[-1]#
  end
  def fetch
    @tokens.shift
  end
  def decode token
    case token
    when nil
      :fin
    when Symbol
      :nonterminal
    else
      :terminal
    end
  end
  def execute(state, value=nil)
    self.send state, value
  end
  def step
    value = fetch
    @state = decode value
    @acc << execute(state, value)
  end
  def run
    loop do
      step
    end
  end
  def expect(state)
    begin
      step
      raise SyntaxError.new unless @state == state
    rescue StopIteration
      raise SyntaxError
    end
    @acc[-1]
  end

  # state functions
  def fin value
    raise StopIteration
  end
  def terminal value
  @term_p.call value
  end
  def nonterminal op
  @nont_p.call(op, last, expect(:terminal))
  end
end
