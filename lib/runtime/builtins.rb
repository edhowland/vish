# builtins.rb - module Builtins - builtin methods


class BreakCalled < RuntimeError; end

module Builtins
  def self.echo(*args)
    args.map(&:to_s).join(' ') + "\n"
  end

  def self.break
    raise BreakCalled.new
  end
end
