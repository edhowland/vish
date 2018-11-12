# Main requires for Viper lib
require 'rake'


require_relative 'vish/version'
require_relative 'vish/vish_path'

# common stuff
require_relative 'runtime'

# AST analysis stuff
require_relative 'analysis'

# Optimizer stuff
require_relative 'optimizer'


# code emission stuff 
require_relative 'generation'


# compiler stuff
require_relative 'parser'
require_relative 'compiler'

# Runtime only stuff



# anchor nodes

# AST stuff





# bytecode interpreter stuff
require_relative 'interpreter'
require_relative 'checks'

