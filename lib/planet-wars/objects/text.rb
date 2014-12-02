class Text
  attr_accessor :text, :x, :y, :z, :size, :factor_x, :factor_y, :color, :options
  attr_reader :textobject
  def initialize(text, options={})
    @text = text || ""
    @options = options
    @size = options[:size] || 13
    @font = options[:font] || "#{AssetManager.fonts_path}/Alfphabet-IV.ttf"
    @x = options[:x] || 0
    @y = options[:y] || 0
    @z = options[:z] || 1025
    @factor_x = options[:factor_x] || 1
    @factor_y = options[:factor_y] || 1
    @color    = options[:color] || Gosu::Color::WHITE
    @textobject = Gosu::Font[@font, @size]
  end

  def width
    textobject.text_width(@text)
  end

  def height
    textobject.height
  end

  def draw
    @textobject.draw(@text, @x, @y, @z, @factor_x, @factor_y, @color)
  end
end
