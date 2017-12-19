# loop.vsh
add={ :v1 + :v2 }
v1=1; v2=2
acc=0
loop { (:acc ==9) && break; acc=:acc + %add }
:acc
# end of file
