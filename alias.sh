#!/bin/bash
# alias.sh - sets some local aliases
# source ./alias.sh

# Run the intire stack
alias vm='./main.rb empty.vsh'

# Invoke the pry debug enviroment
alias dpry='pry -r ./pry_helper.rb'

export VISUAL=~/src/viper2/bin/viper
export EDITOR=~/src/viper2/bin/viper

vt() {
  t=$1; shift 1
  vn "test/test_${t}.rb" $@
}
rt() {
  ruby "test/test_${1}.rb"
}
# things to make editing files easier
alias vg='vn lib/parser/vish_parser.rb'
alias va='vn lib/parser/ast_transform.rb'
alias todo='git grep TODO | grep -v TODO.md'
alias grep.binding='git grep binding.pry'
filepart() {
  echo ${1%.*}
}
alias ra='ruby test/all_tests.rb'
export PATH=$PATH:$PWD/bin

