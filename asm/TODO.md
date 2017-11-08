# TODO for asm vasm stuff


## TODO: Implement Target, Label in vdis.rb

Refine jmp, jmpt instructions operands from integer into UnknownTarget.
Grab these in select for that class.
Get a group_by hash from the .pc attribute.
Rename all the .name attributes with lbl#{'%03d' % i.pc}"
Iterating through the hash, make Labels into the output byte strings, using the .name of the target list.first element.
When outputing, Use the .to_s to recreate the :lbl001 for both the labels and the targets.


