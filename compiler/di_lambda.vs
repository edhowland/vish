# di_lambda.vs - attempt to save a lambda in a dict
la=->() { 'hello' }
di=dict('la', :la)
dd=ix(:di, 'la')
%dd()

