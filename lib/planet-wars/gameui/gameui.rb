class GameUI < Chingu::GameState
  attr_accessor :selected
  def initialize(options={})
    super
    setup if defined?(setup)

    @options = options
    $window.show_cursor = true
    title_font_size = AssetManager.theme_data['gameui']['title_font_size']
    tooltip_font_size = AssetManager.theme_data['gameui']['tooltip_font_size']

    options[:title] ||= "Planet Wars"
    options[:title_size] ||= title_font_size
    options[:font] ||= "#{AssetManager.fonts_path}/#{AssetManager.theme_data['gameui']['font']}"
    @elements = []
    @rects    = []
    @tooltip  = Text.new("", x: 1, y: 80, size: tooltip_font_size, font: options[:font], color: AssetManager.theme_color(AssetManager.theme_data['gameui']['tooltip_color']))
    @post_ui_create = true
    @released_left_mouse_button = false
    @released_return = false
    @selected = nil

    title_text_object = Text.new("#{options[:title]}", x: 50, y: 20, font: options[:font], size: options[:title_size], color: AssetManager.theme_color(AssetManager.theme_data['gameui']['title_color']))
    # title_text_object.x = $window.width/3

    @elements.push({
      object: title_text_object
      })
    @background_image = Gosu::Image["#{AssetManager.background_path}/#{AssetManager.theme_data['gameui']['background']}"]
  end

  def draw
    super
    @elements.each do |element|
      element[:object].draw
    end

    @rects.each do |rect|
      fill_rect([rect[:x],rect[:y],rect[:width],rect[:height]],rect[:color],1024)
    end
    @tooltip.draw

    @background_image.draw(0,0,-15)
  end

  def update
    super
    process_ui

    @rects.each do |rect|
      if collision_with(rect) or rect == @selected
        rect[:color]=rect[:hover_color]
        @selected = rect
        @tooltip.text = rect[:tooltip].to_s if defined?(rect[:tooltip])
        @tooltip.y    = rect[:y]+rect[:text][:object].height/2

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
    font_size = AssetManager.theme_data['gameui']['font_size']

    @get_available_y = 100
    unless @rects.nil?
      @rects.each do |rect|
        @get_available_y = rect[:y]+81-20+(font_size-31)
        if @get_available_y > $window.height
          warn "--WARNING: Button with text: \"#{text}\", is not visible."
        end
      end
    end

    color = AssetManager.theme_color(AssetManager.theme_data['gameui']['color'])
    button_color = AssetManager.theme_color(AssetManager.theme_data['gameui']['button']['background'])
    button_hover_color = AssetManager.theme_color(AssetManager.theme_data['gameui']['button']['active_background'])

    options[:color]       ||= color
    options[:background_color] ||= button_color
    options[:hover_color] ||= button_hover_color
    options[:x]           ||= 100 # $window.width/3
    options[:y]           ||= @get_available_y

    @elements.push(
      text={
        object: Text.new("#{text}", x: options[:x], y: options[:y], size: font_size, color: options[:color], font: @options[:font])
      }
    )

    @rects.push(
      {
        text: text,
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

    case method
    when :up
      num = @rects.index(@selected)
      @selected = @rects[num-1] unless num == 0
      @selected = @rects[@rects.count-1] if num == 0

    when :down
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
