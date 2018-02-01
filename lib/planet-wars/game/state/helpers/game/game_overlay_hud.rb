class GameOverlayHUD
  def initialize
    @show = false
    @ship = Ship.all.first
    @elements = []
    @bases = 1
    @title = Text.new("Telemetry", color: Gosu::Color::WHITE, x: 200, y: 150, z: 1001, size: 32)
    @elements << {text: Text.new("", color: Gosu::Color::WHITE, x: 200, y: 200, z: 1001, size: 20), name: "Bases Built", block: :bases}
    @elements << {text: Text.new("", color: Gosu::Color::WHITE, x: 200, y: 220, z: 1001, size: 20), name: "Available Planets", block: :available_planets}
    @elements << {text: Text.new("", color: Gosu::Color::WHITE, x: 200, y: 240, z: 1001, size: 20), name: "Enemies Killed", block: :enemies_killed}
    @elements << {text: Text.new("", color: Gosu::Color::WHITE, x: 200, y: 260, z: 1001, size: 20), name: "Enemies Active", block: :enemies_active}
    @elements << {text: Text.new("", color: Gosu::Color::WHITE, x: 200, y: 280, z: 1001, size: 20), name: "Bullets Fired", block: :bullets_fired}
    @elements << {text: Text.new("", color: Gosu::Color::WHITE, x: 200, y: 300, z: 1001, size: 20), name: "Ship Repaired", block: :ship_repaired}
  end

  def draw
    if @show
      $window.flush
       $window.draw_rect(100, 100, $window.width-200, $window.height-200, Gosu::Color.argb(200, 0, 0, 0), 1000)
       @elements.each do |e|
         e[:text].draw
       end
       @title.draw
       $window.draw_rect(110, 180, $window.width-220, 4, Gosu::Color::WHITE, 1000)
    end
  end

  def update
    if $window.button_down?(Gosu::KbTab)
      @show = true
      update_text_objects
    else
      @show = false
    end
  end

  def update_text_objects
    @elements.each do |e|
      e[:text].text = "#{e[:name]}: #{self.send(e[:block])}"
    end
  end

  def bases
    bases = []
    Planet.all.select{|planet| if planet.base; bases << planet;end;}
    bases.count
  end

  def available_planets
    Planet.all.count
  end

  def enemies_killed
    GameInfo::Kills.kills
  end

  def enemies_active
    Enemy.all.count
  end

  def bullets_fired
    GameInfo::Config.bullets_fired
  end

  def ship_repaired
    GameInfo::Config.repairs
  end
end
