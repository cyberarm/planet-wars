class GameUI < Chingu::GameState
  attr_accessor :selected
  def initialize(options={})
    super
    @options = options
    $window.show_cursor = true
    options[:title] ||= "Planet Wars"
    options[:title_size] ||= 50
    options[:font] ||= "#{AssetManager.fonts_path}/Hobby-of-night.ttf"
    @elements = []
    @rects    = []
    @tooltip  = Text.new("", x: 1, y: 80, size: 32, font: options[:font])
    @post_ui_create = true
    @released_left_mouse_button = false
    @released_return = false
    @selected = nil

    @elements.push({
      object: Text.new("#{options[:title]}",
      x: 90,
      y: 20,
      font: options[:font],
      size: options[:title_size])
      })
  end

  def draw
    super
    @elements.each do |element|
      element[:object].draw
    end

    @rects.each do |rect|
      fill_rect([rect[:x],rect[:y],rect[:width],rect[:height]],rect[:color])
    end
    @tooltip.draw
  end

  def update
    super
    process_ui

    @rects.each do |rect|
      if collision_with(rect) or rect == @selected
        rect[:color]=rect[:hover_color]
        @selected = rect
        @tooltip.text = rect[:tooltip].to_s if defined?(rect[:tooltip])
        @tooltip.y    = rect[:y]+10

        if collision_with(rect) && @released_left_mouse_button
          rect[:block].call
        elsif @released_return
          rect[:block].call
        end
      else
        rect[:color]=rect[:old_color]
      end
    end

    post_ui_create

    @tooltip.text = "" unless show_tooltip?
    @released_left_mouse_button = false
    @released_return = false
    @post_ui_create = false
  end

  def button_up(id)
    if id == Gosu::MsLeft
      @released_left_mouse_button = true

    elsif id == Gosu::KbEnter or id == Gosu::KbReturn or id == Gosu::GpButton0
      @released_return = true

    elsif id == Gosu::KbUp or id == Gosu::GpUp
      ui_select(:up)

    elsif id == Gosu::KbDown or id == Gosu::GpDown
      ui_select(:down)
    end
  end

  def collision_with(rect)
    if $window.mouse_x.between?(rect[:x],rect[:x]+rect[:width]) && $window.mouse_y.between?(rect[:y],rect[:y]+rect[:height])
      return true
    else
      return false
    end
  end

  def button(text,options={}, &block)
    @get_available_y = 100
    unless @rects.nil?
      @rects.each do |rect|
        @get_available_y = rect[:y]+81-20
        if @get_available_y > $window.height
          warn "--WARNING: Button with text: \"#{text}\", is not visible."
        end
      end
    end

    options[:color]       ||= Gosu::Color::WHITE
    options[:background_color] ||= Gosu::Color.rgba(255,120,0,255)
    options[:hover_color] ||= Gosu::Color.rgba(255,80,0,255)
    options[:x]           ||= 100
    options[:y]           ||= @get_available_y
    @elements.push(
      text={
        object: Text.new("#{text}", x: options[:x], y: options[:y], size: 32, color: options[:color], font: @options[:font])
      }
    )
    
    @rects.push(
      {
        x: options[:x]-10,
        y: options[:y]-10,
        width: text[:object].width+20,
        height: text[:object].height+20,
        color: options[:background_color],
        old_color: options[:background_color],
        hover_color: options[:hover_color],
        block: block,
        tooltip: options[:tooltip]
      }
    )
  end

  def process_ui
    @big = nil
    @rects.each do |rect|
      unless @big
        @big = rect
      end

      if @big[:width] < rect[:width]
        @big = rect
      end
    end

    @tooltip.x = @big[:width]+120

    @rects.each do |rect|
      rect[:width]=@big[:width]
    end
  end

  def post_ui_create
    @selected = @rects.first if @post_ui_create
  end

  def ui_select(method)
    if @selected == nil
      @selected = @rects.first
    end

    if method == :up
      num = @rects.index(@selected)
      @selected = @rects[num-1] unless num == 0
      @selected = @rects[@rects.count-1] if num == 0

    elsif method == :down
      num = @rects.index(@selected)
      if @rects.count-1<num+1
        @selected = @rects.first
      else
        @selected = @rects[num+1]
      end
    end
  end

  def show_tooltip?
    show = false
    @rects.each do |rect|
      if rect[:color] == rect[:hover_color]
        show = true
      end
    end

    return show
  end
end