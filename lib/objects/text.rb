class Text
  attr_accessor :text, :x, :y, :z, :size
  attr_reader :textobject
  def initialize(text, options={})
    @text = text || ""
    @size = options[:size] || 13
    @x = options[:x] || 0
    @y = options[:y] || 0
    @z = options[:z] || 0
    @textobject = Gosu::Font.new($window, "./fonts/Alfphabet-IV.ttf", @size)
  end

  def draw
    @textobject.draw(@text, @x, @y, @z)
  end
end