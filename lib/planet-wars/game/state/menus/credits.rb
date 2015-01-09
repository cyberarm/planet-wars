class PWText < Text
  def initialize(string="", options={})
    super(string, options)
    options['font'] = "#{AssetManager.fonts_path}/Hobby-of-night.ttf"
  end
end

class Credits < GameUI
  trait :timer

  def initialize(options={})
    options[:title] = "#{GameInfo::NAME}//Credits"
    options[:title_size] = 30
    super

    button "Back" do
      push_game_state(MainMenu)
    end

    @text=[]
    load_credit_data

    after(3000) do
      @scroll = true
    end
  end

  def draw
    super
    @text.each(&:draw)
  end

  def update
    super
    if @scroll
      @text.each do |t|
        t.y-=0.6
      end
      push_game_state(MainMenu) if @text.last.y < -@text.last.height
    end
  end

  def load_credit_data
    x    = 340
    y    = $window.height+10
    size = 30
    data = AssetManager.credits_data

    @text << PWText.new(GameInfo::NAME, x: x, y: $window.height/2-40, size: 100)

    @text << PWText.new("People", x: x, y: y, size: size, color: Gosu::Color::YELLOW)
    y+=size
    data['credits']['people'].each do |person|
      @text << PWText.new(person['job'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(person['name'], x: x, y: y, size: size)
      y+=size
      y+=size
    end

    y+=size
    @text << PWText.new("Sprites", x: x, y: y, size: size, color: Gosu::Color::YELLOW)
    y+=size
    data['credits']['sprites'].each do |artist|
      @text << PWText.new(artist['sprite'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(artist['name'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(artist['license'], x: x, y: y, size: size)
      y+=size
      y+=size
    end

    y+=size
    @text << PWText.new("Music", x: x, y: y, size: size, color: Gosu::Color::YELLOW)
    y+=size
    data['credits']['music'].each do |song|
      @text << PWText.new(song['name'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(song['composer'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(song['license'], x: x, y: y, size: size)
      y+=size
      y+=size
    end

    y+=size
    @text << PWText.new("Fonts", x: x, y: y, size: size, color: Gosu::Color::YELLOW)
    y+=size
    data['credits']['fonts'].each do |font|
      @text << PWText.new(font['font'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(font['name'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(font['license'], x: x, y: y, size: size)
      y+=size
      y+=size
    end

    y+=size
    @text << PWText.new("Libraries", x: x, y: y, size: size, color: Gosu::Color::YELLOW)
    y+=size
    data['credits']['libraries'].each do |font|
      @text << PWText.new(font['name'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(font['author'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(font['license'], x: x, y: y, size: size)
      y+=size
      y+=size
    end
  end
end
