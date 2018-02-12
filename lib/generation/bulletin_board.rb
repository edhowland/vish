# bulletin_board.rb - class BulletinBoard

# A real life bulletin board is a communication scheme for disconnected
#  and anonymous parties. This BulletinBoard serves the same function, but for
# disconnectd compiler objects. JumpTargets are created and then looked up  when
#  needed. This serves as a single point ofcommunication for two passes
# of the compiler analysis phase and generation phases.

class BulletinBoard
  @@storage = {}
  class << self
    def post target
      @@storage[target.name] = target
    end
    def get target_name
      @@storage[target_name.to_sym]
    end

    # put(target) - Idempotent. Does not store it if it exists
    def put(target)
      @@storage[target.name] || @@storage[target.name] = target
    end
    def keys
      @@storage.keys
    end

    def values
      @@storage.values
    end

  def storage
    @@storage
  end

    def clear
      @@storage.clear
    end
  end

end
