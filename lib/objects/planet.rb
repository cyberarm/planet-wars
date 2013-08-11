class Planet < Chingu::GameObject
  trait :effect
  trait :bounding_circle
  trait :collision_detection

  attr_reader :name, :habitable, :high_temp, :low_temp
  attr_accessor :text, :gold, :diamond, :oil

  def setup
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

    @image = Gosu::Image["planets/planet-0#{rand(1..2)}.png"] if habitable
    @image = Gosu::Image["planets/planet-0#{rand(3..3)}.png"] unless habitable
    self.scale_out(rand(0.5..0.9))
    self.rotate(rand(120))
    
    @rate = rand(-3.0..3.0)
    @text = Chingu::Text.new("", x: self.x, y: self.y, zorder: 1, size: 20)
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
  end


  def collision_check
    if self.bounding_circle_collision?(Ship.all.first)
      self.text.text = "#{name}\nHabitable: #{habitable}\nTemperature:\n  High:#{high_temp}\n  Low: #{low_temp}\nResources:\n  Diamond: #{diamond}\n  Gold: #{gold}\n  Oil: #{oil}"
    else
      self.text.text = ''
    end
  end

  def button_down?(id)
    $window.button_down?(id)
  end
end