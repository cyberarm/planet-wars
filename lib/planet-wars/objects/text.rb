class Text
  CACHE = {}

  attr_accessor :text, :x, :y, :z, :size, :factor_x, :factor_y, :color, :shadow, :shadow_size, :options
  attr_reader :textobject

  def initialize(text, options={})
    @text = text || ""
    @options = options
    @size = options[:size] || AssetManager.theme_data['text']['font_size']
    @font = options[:font] || "#{AssetManager.fonts_path}/#{AssetManager.theme_data['text']['font']}"
    @x = options[:x] || 0
    @y = options[:y] || 0
    @z = options[:z] || 1025
    @factor_x = options[:factor_x]  || 1
    @factor_y = options[:factor_y]  || 1
    @color    = options[:color]     || Gosu::Color::WHITE
    @alignment= options[:alignment] || nil
    @shadow   = true  if options[:shadow] == true
    @shadow   = false if options[:shadow] == false
    @shadow   = true if options[:shadow] == nil
    @shadow_size = options[:shadow_size] ? options[:shadow_size] : 1
    @shadow_alpha= options[:shadow_alpha] ? options[:shadow_alpha] : 30
    @textobject = check_cache(@size, @font)

    if @alignment
      case @alignment
      when :left
        @x = 0+BUTTON_PADDING
      when :center
        @x = ($window.width/2)-(@textobject.text_width(@text)/2)
      when :right
        @x = $window.width-BUTTON_PADDING-@textobject.text_width(@text)
      end
    end

    return self
  end

  def check_cache(size, font_name)
    available = false
    font      = nil

    if CACHE[size]
      if CACHE[size][font_name]
        font = CACHE[size][font_name]
        available = true
      else
        available = false
      end
    else
      available = false
    end

    unless available
      font = Gosu::Font.new(@size, name: @font)
      CACHE[@size] = {} unless CACHE[@size].is_a?(Hash)
      CACHE[@size][@font] = font
    end

    return font
  end

  def width
    textobject.text_width(@text)
  end

  def height
    textobject.height
  end

  def draw
    if @shadow && !ARGV.join.include?("--no-shadow")
      _color = Gosu::Color.rgba(@color.red, @color.green, @color.blue, @shadow_alpha) if @shadow_alpha <= @color.alpha
      _color = Gosu::Color.rgba(@color.red, @color.green, @color.blue, @color.alpha) unless @shadow_alpha <= @color.alpha
      @textobject.draw(@text, @x-@shadow_size, @y, @z, @factor_x, @factor_y, _color)
      @textobject.draw(@text, @x-@shadow_size, @y-@shadow_size, @z, @factor_x, @factor_y, _color)

      @textobject.draw(@text, @x, @y-@shadow_size, @z, @factor_x, @factor_y, _color)
      @textobject.draw(@text, @x+@shadow_size, @y-@shadow_size, @z, @factor_x, @factor_y, _color)

      @textobject.draw(@text, @x, @y+@shadow_size, @z, @factor_x, @factor_y, _color)
      @textobject.draw(@text, @x-@shadow_size, @y+@shadow_size, @z, @factor_x, @factor_y, _color)

      @textobject.draw(@text, @x+@shadow_size, @y, @z, @factor_x, @factor_y, _color)
      @textobject.draw(@text, @x+@shadow_size, @y+@shadow_size, @z, @factor_x, @factor_y, _color)
    end

    @textobject.draw(@text, @x, @y, @z, @factor_x, @factor_y, @color)
  end

  def update; end
end
