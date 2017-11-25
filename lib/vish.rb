# Main requires for Viper lib

require 'rubytree'
require 'highline'

# common stuff
require_relative 'api'

# compiler stuff
require_relative 'ast'
require_relative 'parser'
require_relative 'compiler'

# Runtime only stuff
require_relative 'runtime'


require_relative 'error_state'
require_relative 'stack_not_empty'
require_relative 'halt_state'
require_relative 'opcode_error'
require_relative 'bytecodes'
require_relative 'context'

# anchor nodes

# AST stuff
require_relative 'mknode'



# AST analysis stuff
require_relative 'analysis'


# code emission stuff 
require_relative 'emit_walker'

# bytecode interperter stuff
require_relative 'interperter'
