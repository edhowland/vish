# reader.rb - wraper on TTY::Reader from tty-reader gem

require 'tty-reader'
require_relative '../lib/vish'

$reader = TTY::Reader.new
$reader.on(:keyctrl_d) {|k| exit(0) }
eval = Evaluator.new

def vish_eval(evaluator , _=nil, &blk)
  begin
    source = yield if block_given?
    _ = evaluator.eval(source) {|i| i.ctx.vars[:_] = _ } unless source.strip.empty?
    _ 
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

def repl(ev)
  seed=nil
loop do
  result =vish_eval(ev, seed) { reader }
  p result
  seed = result
  end
end



repl(eval)
