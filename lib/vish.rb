# Main requires for Viper lib

require 'rubytree'
require_relative 'vish/version'


# common stuff
require_relative 'api'
require_relative 'runtime'


# compiler stuff
require_relative 'ast'
require_relative 'parser'
require_relative 'compiler'

# Runtime only stuff


require_relative 'halt_state'
require_relative 'opcode_error'
require_relative 'bytecodes'

# anchor nodes

# AST stuff
require_relative 'mknode'



# AST analysis stuff
require_relative 'analysis'


# code emission stuff 
require_relative 'generation'


# bytecode interpreter stuff
require_relative 'interpreter'
require_relative 'evaluation'

