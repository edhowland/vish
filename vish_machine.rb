# vish_machine.rb - VM to run Vish byte code
# Derives from CodeInterpreter

class VishMachine
  def initialize bc, ctx
    @bc = bc
    @ctx = ctx
    @frames = LockedStack.new limit: 1000
    @frames.push(MainFrame.new(@ctx))

    @opcodes = opcodes
  end
  attr_reader :bc, :frames

  def ctx
    @frames.peek.ctx
  end
  def fetch
    @bc.next
  end
  def decode(code)
    @opcodes[code]
  end
  def execute(blob)
    blob.call(@bc, ctx, @frames, self)
  end

  def step
    code = fetch
    blob = decode(code)
    execute(blob)
  end

  # Run loop until fault or HaltState raised
  def run(start=0)
    @bc.pc = start
    loop do
      begin
        step
    rescue HaltState
      raise StopIteration
      end
    end
    @ctx.stack.peek
  end
end

