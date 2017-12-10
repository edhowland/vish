# builtins.rb - module Builtins - builtin methods


class BreakCalled < RuntimeError; end

module Builtins
  def self.echo(*args)
    args.map(&:to_s).join(' ') + "\n"
  end

  def self.except(*args)
    raise (args[0] || 'Unknown exception')
  end

  def self.read(*args)
    gets.chomp
  end

  # readi - reads and returns integer
  def self.readi(*args)
    read(*args).to_i
  end

  # Linked list stuff
  def self.list(*args)
    args.flatten
  end
  def self.head(*args)
    args[0][0]
  end

  def self.tail(*args)
    args[0][1..(-1)]
  end

  def self.print(*args)
    $stdout.puts args.inspect
  end
end
