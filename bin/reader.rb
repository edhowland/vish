# reader.rb - wraper on TTY::Reader from tty-reader gem

require 'tty-reader'

$reader = TTY::Reader.new
$reader.on(:keyctrl_d) {|k| exit(0) }


def reader(prompt='vish> ')
  s=$reader.read_line(prompt)
  s.chomp
#  $reader.add_to_history s
  s
end

#4.times do
#  puts reader
#  end

  