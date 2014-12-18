class Planet < Chingu::GameObject
  trait :effect
  trait :bounding_circle
  trait :collision_detection

  attr_reader :name, :high_temp, :low_temp
  attr_accessor :text, :habitable, :base, :gold, :diamond, :oil

  def setup
    self.zorder = 150
    @name = NameGen.new.name
    case rand(1..2)
    when 1
      @habitable = true
    when 2
      @habitable = false
    end
    @high_temp = rand(33..100) if habitable
    @low_temp = rand(1..33) if habitable

    @high_temp = rand(120..400) unless habitable
    @low_temp = rand(-400..0) unless habitable

    @diamond = rand(0..100)
    @gold    = rand(0..400)
    @oil     = rand(0..400)

    if habitable
      planet_images = Dir["#{AssetManager.planets_path}/habitable/*.png"]
      random = rand(planet_images.count)
      @image = Gosu::Image["#{AssetManager.planets_path}/habitable/#{File.basename(planet_images[random])}"]
    else
      planet_images = Dir["#{AssetManager.planets_path}/uninhabitable/*.png"]
      random = rand(planet_images.count)
      @image = Gosu::Image["#{AssetManager.planets_path}/uninhabitable/#{File.basename(planet_images[random])}"]
    end

    self.scale_out(rand(0.5..0.9))
    self.rotate(rand(120))

    @rate = rand(-3.0..3.0)
    @text = Text.new("", x: self.x-(self.width/4), y: self.y, zorder: 999, size: 20)

    @base = nil
  end

  def rotate_self
    self.rotate(@rate)
  end

  def draw
    super
    @text.draw
  end

  def update
    self.rotate_self
    collision_check
    @base.update if @base.is_a?(Base)
  end

  def collision_check
    unless @base.is_a?(Base)
      if self.bounding_circle_collision?(Ship.all.first)
        self.text.text = "#{name}"
      else
        self.text.text = ''
      end
    else
      self.text.text = "#{name}"
      self.text.color= Gosu::Color::GREEN
    end
  end

  def button_down?(id)
    $window.button_down?(id)
  end
end
