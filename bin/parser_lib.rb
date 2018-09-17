# parser_lib.rb - module ParserLib
require_relative '../lib/vish'

module ParserLib
  def self.parse(string)
    c = VishCompiler.new string
    c.parse
    c.transform
    c.analyze
    c.ast
  end
  ## _emit(AST) :  Given a AST node subtree, return the emitted bytecodes
  def self._emit(ast)
    Semit.new.emit(ast)
  end
end

Dispatch << ParserLib
