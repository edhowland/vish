# Bugs for asm/

## Bug: operands remain strings even when they should be ints

Create new class Operand sibling of Target. Both
classes need to have a resolv(opcode)e method. Targets is a no operation.
Operand will check if its opcode requires it to convert to int, vi :to_i
