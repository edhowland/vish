# parser_lib.rb - module ParserLib
require_relative '../lib/vish'

module ParserLib
  def self.parse(string)
    c = VishCompiler.new string
    c.parse
    c.transform
    c.ast
  end
end

Dispatch << ParserLib
