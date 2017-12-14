# Manifest for vish source

- asm : vasm.rb and vdis.rb to assemble, disassemble .vasm, .vshc files
- bin - vish executable
- common - common files for asm/ runtime and vish internals
- compiler : vishc file.vsh file.vshc - compiles Vish source into bytecode file
- lib - directory tree of Vish library code. Including compiler stuff
- runtime : vre file.vshc - runs compiled Vish .vshc files in bytecode interperter

## bin contents

- vish - CLI tool to evaluate and run Vish scripts: *.vs
- ivs - (Eventually) Interactive Vish REPL
