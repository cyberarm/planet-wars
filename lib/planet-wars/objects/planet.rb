class Planet < GameObject
  attr_reader :name, :high_temp, :low_temp
  attr_accessor :text, :habitable, :base, :gold, :diamond, :oil

  def setup
    @debug_color = Gosu::Color::CYAN

    self.z = 150
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
      @image = AssetManager.get_image("#{AssetManager.planets_path}/habitable/#{File.basename(planet_images[random])}")
    else
      planet_images = Dir["#{AssetManager.planets_path}/uninhabitable/*.png"]
      random = rand(planet_images.count)
      @image = AssetManager.get_image("#{AssetManager.planets_path}/uninhabitable/#{File.basename(planet_images[random])}")
    end

    self.scale=rand(0.5..0.9)
    self.rotate(rand(120))

    @rate = rand(-3.0..3.0)*60
    @text = Text.new("#{@name}", x: self.x-(self.width/4), y: self.y, z: 999, size: 20, color: AssetManager.theme_color(AssetManager.theme_data['hud']['planets']['habitable'])) if @habitable
    @text = Text.new("#{@name}", x: self.x-(self.width/4), y: self.y, z: 999, size: 20, color: AssetManager.theme_color(AssetManager.theme_data['hud']['planets']['unhabitable'])) unless @habitable

    @text.x = (self.x-(self.width.to_f*scale)/2)+((@text.width.to_f/2)*scale)
    @text.text = ""
    @base = nil
  end

  def rotate_self
    rate = @rate*Engine.dt

    self.rotate(rate)
  end

  def draw
    super
    @text.draw
    @base.draw if @base.is_a?(Base)
  end

  def update
    self.rotate_self
    collision_check
    @base.update if @base.is_a?(Base)
  end

  def collision_check
    unless @base.is_a?(Base)
      if self.circle_collision?(Ship.all.first)
        self.text.text = "#{name}"
      else
        self.text.text = ''
      end
    else
      self.text.text = "#{name}"
      self.text.color= AssetManager.theme_color(AssetManager.theme_data['hud']['planets']['base'])
    end
  end

  def button_down?(id)
    $window.button_down?(id)
  end
end
