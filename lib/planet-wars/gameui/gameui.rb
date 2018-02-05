class GameUI < GameState
  Mouse = Struct.new(:x, :y)
  attr_accessor :selected
  def setup
    @elements = []
    @rects    = []
    @options = options unless @options

    # Sounds
    @change = AssetManager.get_sample("#{AssetManager.sounds_path}/ui/change.ogg")
    @action = AssetManager.get_sample("#{AssetManager.sounds_path}/ui/action.ogg")


    $window.show_cursor = true
    title_font_size = AssetManager.theme_data['gameui']['title_font_size']
    tooltip_font_size = AssetManager.theme_data['gameui']['tooltip_font_size']

    @options[:title] ||= "Planet Wars"
    @options[:title_size] ||= title_font_size
    @options[:font] ||= "#{AssetManager.theme_data['gameui']['font']}"
    @tooltip  = Text.new("", x: 1, y: 80, size: tooltip_font_size, font: @options[:font], color: AssetManager.theme_color(AssetManager.theme_data['gameui']['tooltip_color']))
    @post_ui_create = true
    @released_left_mouse_button = false
    @released_return = false

    @selected = nil
    @old_selected = nil

    @mouse = Mouse.new($window.mouse_x, $window.mouse_y)
    @old_mouse = Mouse.new($window.mouse_x, $window.mouse_y)
    @mouse_tick=0
    @first_passed=false

    @title_text_object = Text.new("#{options[:title]}", x: 50, y: 20, font: @options[:font], size: @options[:title_size], color: AssetManager.theme_color(AssetManager.theme_data['gameui']['title_color']))

    @elements.push({
      object: @title_text_object
      })

    create if defined?(create)
    raise "method 'create' is not defined!" unless defined?(create)
  end

  def draw
    $window.flush
    super
    @rects.each do |rect|
      fill_rect(rect[:x],rect[:y],rect[:width],rect[:height],rect[:color], 10)
    end
    @elements.each do |element|
      element[:object].draw
    end
    @tooltip.draw

    # @background_image.draw(0,0,-15)
    fill_rect(0, 0, Gosu.screen_width, Gosu.screen_height, AssetManager.theme_color(AssetManager.theme_data['gameui']['background']), -15)
  end

  def update
    super
    process_ui
    @mouse_tick+=1

    @rects.each do |rect|
      if (collision_with(rect) && mouse_updated?) or rect == @selected
        rect[:color]=rect[:hover_color]
        @selected = rect
        @tooltip.text = rect[:tooltip].to_s if defined?(rect[:tooltip])
        @tooltip.y    = rect[:y]+rect[:text][:object].height/2
        unless @first_passed
          @change.play unless (@selected == @old_selected) && !muted
        end
        @old_selected = @selected

        if collision_with(rect) && @released_left_mouse_button
          rect[:block].call
          @action.play unless muted
        elsif @released_return
          rect[:block].call
          @action.play unless muted
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
    @mouse.x = $window.mouse_x
    @mouse.y = $window.mouse_y

    if @mouse_tick >= 10
      @mouse_tick = 0
      @old_mouse = @mouse.dup
    end
  end

  def button_up(id)
    if id == Gosu::MsLeft
      @released_left_mouse_button = true

    elsif id == Gosu::KbEnter || id == Gosu::KbReturn || id == Gosu::KbSpace || id == Gosu::GpButton0
      @released_return = true

    elsif id == Gosu::KbUp || id == Gosu::GpUp || id == Gosu::KbW
      ui_select(:up)

    elsif id == Gosu::KbDown || id == Gosu::GpDown || id == Gosu::KbS
      ui_select(:down)

    elsif id == Gosu::KbEscape || id == Gosu::GpButton1
      go_back
    end
  end

  def set_title(string)
    @title_text_object.text = string
  end

  def collision_with(rect)
    boolean = false
    if @mouse.x.between?(rect[:x],rect[:x]+rect[:width]) && @mouse.y.between?(rect[:y],rect[:y]+rect[:height])
      boolean = true
    end
    return boolean
  end

  def mouse_updated?
    boolean = false
    if @mouse.x.between?(@old_mouse.x - 5, @old_mouse.x + 5)
      if @mouse.y.between?(@old_mouse.y - 5, @old_mouse.y + 5)
        boolean = false
      else
        boolean = true
      end

    else
      boolean = true
    end

    return boolean
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

    @tooltip.x = @big[:x]+@big[:width]+40 if @big


    @rects.each do |rect|
      rect[:width]=@big[:width]
    end
  end

  def post_ui_create
    if @post_ui_create
       @selected = @rects.first
       @first_passed = true
    end
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
      @change.play unless muted

    when :down
      num = @rects.index(@selected)
      if @rects.count-1<num+1
        @selected = @rects.first
      else
        @selected = @rects[num+1]
      end

      @change.play unless muted
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

  def go_back
    # if $window.previous_game_state && $window.previous_game_state.class.to_s.end_with?("Menu")
      # push_game_state($window.previous_game_state)
      # @action.play unless muted
    # end
  end

  def muted
    !ConfigManager.play_sounds?
  end
end
