# loop.vsh - counter up to 10
val=0
loop { (:val == 10) && return true; val=:val + 1 }
:val
