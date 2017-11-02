#!/bin/bash
# alias.sh - sets some local aliases
# source ./alias.sh

# Run the intire stack
alias vm='./main.rb empty.vsh'

# Invoke the pry debug enviroment
alias dpry='pry -r ./pry_helper.rb'

export VISUAL=~/src/viper2/bin/viper

# test : run tests via rake test
alias test='rake test'