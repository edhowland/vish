# loop_entry.rb - class  LoopEntry < Terminal - what to do upon entry of a loop

class LoopEntry < Terminal
  attr_reader :loop_frame, :jump_to
  # TODO: emit a :frame which pushes activation frame on ctx.call_stack
  def emit(bc, ctx)
    bc.codes << :frame
    @loop_frame = LoopFrame.new
    bc.codes << @loop_frame
    @jump_to = bc.codes.length
  end
end
