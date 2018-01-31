class NotificationManager < GameObject
  Z = 999

  attr_accessor :slot
  def setup
    @slot = []
  end

  def self.add(text, color=Gosu::Color::WHITE, active=180)
    # managers = NotificationManager.all
    # note = managers.last
    # p note.methods-Class.methods
    # note.slot << Text.new(text, active: active, color: color, size: 23, x: 100, z: Z, tick: 0)
  end

  def slot
    @slot = [] unless @slot
  end

  def draw
    @slot.reverse.each do |note|
      note.draw
    end
  end

  def update
    n = 1
    @slot.each do |note|
      note.y = note.size*n
      note.options[:tick]+=1
      if note.options[:tick] >= note.options[:active]
        @slot.delete(note)
      else
        n+=1
      end
    end
  end
end
