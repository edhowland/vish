# reader.rb - wraper on TTY::Reader from tty-reader gem

require 'tty-reader'
require_relative '../lib/vish'

$reader = TTY::Reader.new
$reader.on(:keyctrl_d) {|k| exit(0) }
eval = Evaluator.new

def vish_eval(evaluator , &blk)
  begin
    s = yield if block_given?
    s.chomp!
  rescue TTY::Reader::InputInterrupt # SigInt
    # clear the input buffer
  rescue Parslet::ParseFailed => err
    puts "Syntax Error: #{err.message}"
  rescue VishRuntimeError => err
    puts "Runtime error: #{err.message}"
  rescue CompileError => err
    puts "Compile error: #{err.message}"
  end
end

def reader(prompt='vish> ')
  s=$reader.read_line(prompt)
  s.chomp
end

def readit(ev)
4.times do
  result =vish_eval(ev) { reader }
  puts result
  end
end

readit(eval) if ARGV.length >= 1