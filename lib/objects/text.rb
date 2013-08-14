class Text
  attr_accessor :text, :x, :y, :z, :size, :factor_x, :factor_y, :color
  attr_reader :textobject
  def initialize(text, options={})
    @text = text || ""
    @size = options[:size] || 13
    @x = options[:x] || 0
    @y = options[:y] || 0
    @z = options[:z] || 999
    @factor_x = options[:factor_x] || 1
    @factor_y = options[:factor_y] || 1
    @color = options[:color] || Gosu::Color::WHITE
    @textobject = Gosu::Font.new($window, "#{AssetManager.fonts_path}/Alfphabet-IV.ttf", @size)
  end

  def draw
    @textobject.draw(@text, @x, @y, @z, @factor_x, @factor_y, @color)
  end
end