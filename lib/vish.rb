# Main requires for Viper lib

require 'rubytree'
require_relative 'vish/version'

# common stuff
require_relative 'runtime'
require_relative 'api'


# compiler stuff
require_relative 'ast'
require_relative 'parser'
require_relative 'compiler'

# Runtime only stuff


require_relative 'opcode_error'

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
require_relative 'checks'

