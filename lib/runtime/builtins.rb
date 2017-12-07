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
end
