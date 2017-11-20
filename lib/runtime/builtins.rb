# builtins.rb - module Builtins - builtin methods


module Builtins
  def self.echo(*args)
    args.map(&:to_s).join(' ') + "\n"
  end
end
