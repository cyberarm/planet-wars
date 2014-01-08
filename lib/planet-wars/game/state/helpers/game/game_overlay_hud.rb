class GameOverlayHUD
  def initialize
    @show = false
    @ship = Ship.all.first
    @elements = []
    @bases = 1
    @elements << {text: Text.new("", x: 200, y: 200, zorder: 1001, size: 20), name: "Bases Built", block: :bases}
    @elements << {text: Text.new("", x: 200, y: 220, zorder: 1001, size: 20), name: "Available Planets", block: :available_planets}
    @elements << {text: Text.new("", x: 200, y: 240, zorder: 1001, size: 20), name: "Enemies Kills", block: :enemies_killed}
    @elements << {text: Text.new("", x: 200, y: 260, zorder: 1001, size: 20), name: "Bullets Fired", block: :bullets_fired}
  end

  def draw
    if @show
       $window.fill_rect([100, 100, $window.width-300, $window.height-300], Gosu::Color.argb(175, 100, 100, 100), 1000)
       @elements.each do |e|
         e[:text].draw
       end
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
    planets = []
    Planet.all.select do |planet|
       unless planet.base
         if planet.habitable
           planets << planet
         end
       end
     end
    planets.count
  end

  def enemies_killed
    GameInfo::Config.kills
  end

  def bullets_fired
    GameInfo::Config.bullets_fired
  end
end