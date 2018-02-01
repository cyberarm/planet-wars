class PWText < Text
  def initialize(string="", options={})
    super(string, options)
    # options['font'] = "#{AssetManager.fonts_path}/Hobby-of-night.ttf"
  end
end

class Credits < GameUI
  def initialize(options={})
    options[:title] = "#{GameInfo::NAME}//Credits"
    options[:title_size] = 30
    super

    button "Back" do
      push_game_state(MainMenu)
    end

    @text=[]

    @start_time = Gosu.milliseconds
    load_credit_data
  end

  def draw
    super
    @text.each(&:draw)
  end

  def update
    super
    @scroll = true

    if @scroll
      @text.each do |t|
        t.y-=10 if $window.button_down?(Gosu::KbDown)
        t.y-=0.6 unless $window.button_down?(Gosu::KbDown)
        t.y+=5 if $window.button_down?(Gosu::KbUp)
      end
      push_game_state(MainMenu) if @text.last.y < -@text.last.height
    end
  end

  def header_color
    color = AssetManager.theme_data["gameui"]["button"]["active_background"]
    AssetManager.theme_color(color)
  end

  def load_credit_data
    x    = 340
    y    = $window.height+10
    size = 30
    data = AssetManager.credits_data

    @text << PWText.new(GameInfo::NAME, x: x, y: $window.height/2-40, size: 75)

    @text << PWText.new("People", x: x, y: y, size: size, color: header_color)
    y+=size
    data['credits']['people'].each do |person|
      @text << PWText.new(person['job'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(person['name'], x: x, y: y, size: size-7)
      y+=size
      y+=size
    end

    y+=size
    @text << PWText.new("Sprites", x: x, y: y, size: size, color: header_color)
    y+=size
    data['credits']['sprites'].each do |artist|
      @text << PWText.new(artist['sprite'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(artist['name'], x: x, y: y, size: size-7)
      y+=size
      @text << PWText.new(artist['license'], x: x, y: y, size: size-10)
      y+=size
      y+=size
    end

    y+=size
    @text << PWText.new("Music", x: x, y: y, size: size, color: header_color)
    y+=size
    data['credits']['music'].each do |song|
      @text << PWText.new(song['name'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(song['composer'], x: x, y: y, size: size-7)
      y+=size
      @text << PWText.new(song['license'], x: x, y: y, size: size-10)
      y+=size
      y+=size
    end

    y+=size
    @text << PWText.new("Fonts", x: x, y: y, size: size, color: header_color)
    y+=size
    data['credits']['fonts'].each do |font|
      @text << PWText.new(font['font'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(font['name'], x: x, y: y, size: size-7)
      y+=size
      @text << PWText.new(font['license'], x: x, y: y, size: size-10)
      y+=size
      y+=size
    end

    y+=size
    @text << PWText.new("Libraries", x: x, y: y, size: size, color: header_color)
    y+=size
    data['credits']['libraries'].each do |font|
      @text << PWText.new(font['name'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(font['author'], x: x, y: y, size: size-7)
      y+=size
      @text << PWText.new(font['license'], x: x, y: y, size: size-10)
      y+=size
    end
    # @text << MultiLineText.new(Gosu::LICENSES, x: x, y: y, size: size-15)
    ldata = Gosu::LICENSES.split("\n")
    ldata.delete_at(0) # Discard discriptor
    ldata.delete_at(0) if ldata[0].empty?

    ldata.each do |line|
      line.split(",").each_with_index do |l, index|
        p l, index
        if index == 0
          @text << PWText.new(l, x: x, y: y, size: size)
          y+=size
        end
        if index == 1
          @text << PWText.new(l.strip, x: x, y: y, size: size-7)
          y+=size
        end
        if index == 2
          @text << PWText.new(l.strip, x: x, y: y, size: size-10)
          y+=size
        end
        if index == 3
          @text << PWText.new(l.strip, x: x, y: y, size: size-10)
          y+=size
          y+=size
        end
      end
    end
  end
end
