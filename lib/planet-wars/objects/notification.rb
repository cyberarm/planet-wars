class NotificationManager < GameObject
  Z = 999
  QUEUE = []

  attr_accessor :slot
  def setup
    @slot = []
  end

  def self.add(text, color=Gosu::Color::WHITE, active=180)
    text = Text.new(text, active: active, color: color, size: 23, x: 100, z: Z, tick: 0)
    QUEUE << text
  end

  def draw
    @slot.reverse.each do |note|
      note.draw
    end
  end

  def update
    n = 1
    add_from_queue

    @slot.each do |note|
      next if nil
      note.y = note.size*n
      note.options[:tick]+=1
      if note.options[:tick] >= note.options[:active]
        @slot.delete(note)
      else
        n+=1
      end
    end
  end

  def add_from_queue
    text = QUEUE.pop
    # raise "Text is nil" unless text
    slot << text if text
  end
end
