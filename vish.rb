# Main requires for Viper lib

require 'rubytree'

require_relative 'error_state'
require_relative 'stack_not_empty'
require_relative 'halt_state'
require_relative 'opcode_error'
require_relative 'bytecode'
require_relative 'context'
require_relative 'opcodes'
require_relative 'terminal'
require_relative 'non_terminal'
require_relative 'numeral'
require_relative 'binary_add'
require_relative 'lvalue'
require_relative 'assign'
require_relative 'deref'
require_relative 'funcall'

# anchor nodes
require_relative 'start'
require_relative 'final'

# AST stuff
require_relative 'mknode'
require_relative 'binary_tree_factory'
require_relative 'program_factory'


