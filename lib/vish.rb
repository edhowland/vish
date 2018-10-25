# Main requires for Viper lib
require 'rake'


require_relative 'vish/version'
require_relative 'vish/vish_path'

# common stuff
require_relative 'runtime'


# compiler stuff
require_relative 'parser'
require_relative 'compiler'

# Runtime only stuff



# anchor nodes

# AST stuff



# AST analysis stuff
# Restore this whenever some AST analysis is going on
require_relative 'analysis'


# code emission stuff 
require_relative 'generation'


# bytecode interpreter stuff
require_relative 'interpreter'
require_relative 'checks'

