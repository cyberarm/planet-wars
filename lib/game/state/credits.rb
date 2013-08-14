class PWText < Text
end

class Credits < GameUI
  trait :timer

  def initialize(options={})
    options[:title] = "Credits"
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
        t.y-=0.3
      end
      push_game_state(MainMenu) if @text.last.y < 0
    end
  end

  def load_credit_data
    require "yaml"
    x    = 400
    y    = 10
    size = 40
    data = AssetManager.credits_data

    @text << PWText.new("People", x: x, y: y, size: size, color: Gosu::Color::YELLOW)
    y+=size
    data['credits']['people'].each do |person|
      @text << PWText.new(person['job'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(person['name'], x: x, y: y, size: size, color: Gosu::Color::BLUE)
      y+=size
    end
    
    y+=size
    @text << PWText.new("Sprites", x: x, y: y, size: size, color: Gosu::Color::YELLOW)
    y+=size
    data['credits']['sprites'].each do |artist|
      @text << PWText.new(artist['sprite'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(artist['name'], x: x, y: y, size: size, color: Gosu::Color::BLUE)
      y+=size
      @text << PWText.new(artist['license'], x: x, y: y, size: size, color: Gosu::Color::GREEN)
      y+=size
    end

    y+=size
    @text << PWText.new("Music", x: x, y: y, size: size, color: Gosu::Color::YELLOW)
    y+=size
    data['credits']['music'].each do |song|
      @text << PWText.new(song['name'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(song['composer'], x: x, y: y, size: size, color: Gosu::Color::BLUE)
      y+=size
      @text << PWText.new(song['license'], x: x, y: y, size: size, color: Gosu::Color::GREEN)
      y+=size
    end

    y+=size
    @text << PWText.new("Fonts", x: x, y: y, size: size, color: Gosu::Color::YELLOW)
    y+=size
    data['credits']['fonts'].each do |font|
      @text << PWText.new(font['font'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(font['name'], x: x, y: y, size: size, color: Gosu::Color::BLUE)
      y+=size
      @text << PWText.new(font['license'], x: x, y: y, size: size, color: Gosu::Color::GREEN)
      y+=size
    end

    y+=size
    @text << PWText.new("Libraries", x: x, y: y, size: size, color: Gosu::Color::YELLOW)
    y+=size
    data['credits']['libraries'].each do |font|
      @text << PWText.new(font['name'], x: x, y: y, size: size)
      y+=size
      @text << PWText.new(font['author'], x: x, y: y, size: size, color: Gosu::Color::BLUE)
      y+=size
      @text << PWText.new(font['license'], x: x, y: y, size: size, color: Gosu::Color::GREEN)
      y+=size
    end
  end
end