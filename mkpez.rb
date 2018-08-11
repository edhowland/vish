# mkpez.rb - create Pez dispensor / generator
require 'continuation'

def mkpez(ival=0)
  gen = nil
  lambda do
    gen.call unless gen.nil?
    callcc do |ret|
      loop do
        callcc do |next_pass|
          gen = next_pass
          ret.call ival
        end
        ival += 1
      end
    end

  end
end
  require 'continuation'

def generator(*args)
  gen = nil # this is where we stash away the next iteration
  lambda do
    # jump to next iteration if we stashed it away
    return gen.call unless gen.nil?
    callcc do |ret|
      args.each do |element|
        callcc do |next_element|
          # stash away the next iteration
          gen = next_element
          # return the element for the current iteration
          ret.call element
        end # of inner callcc : next_element
      end # of each loop block
    end # of ret block in first callcc
  end # of lambda
end
