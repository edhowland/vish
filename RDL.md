# RDL - Type checking for Ruby

require ' rdl '
 extend RDL
 :: Annotate # add annotation methods
 to current scope type 
' (Integer, Integer) -> String '
 def m ( x , y ) ... end 
