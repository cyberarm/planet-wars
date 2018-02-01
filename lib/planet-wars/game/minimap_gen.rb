class MiniMapGenerator
  attr_reader :image

  def initialize(area, planets, enemies, asteroid, ships)
    #area = [play area width, play area height]
    #objects = [Planets, Stars]
    @area    = area
    @planets = planets
    @enemies = enemies
    @asteroids=asteroid
    @ships   = ships

    @color_planet = AssetManager.theme_color(AssetManager.theme_data['hud']['minimap']['planet_habitable'])
    @color_planet_not_habitable = AssetManager.theme_color(AssetManager.theme_data['hud']['minimap']['planet_uninhabitable'])
    @color_planet_based = AssetManager.theme_color(AssetManager.theme_data['hud']['minimap']['planet_based'])
    @color_asteroid = AssetManager.theme_color(AssetManager.theme_data['hud']['minimap']['asteroid'])
    @color_enemy  = AssetManager.theme_color(AssetManager.theme_data['hud']['minimap']['enemy'])
    @color_ship = AssetManager.theme_color(AssetManager.theme_data['hud']['minimap']['ship'])

    @color_background = background_color(AssetManager.theme_data['hud']['minimap']['background'])

    return @image
  end

  def background_color(color)
    color = Chroma.paint(color).rgb
    return Gosu::Color.rgba(color.r, color.g, color.b, 100)
  end

  def draw
    x = $window.width-(@area.width/10)
    $window.draw_rect(x, 0, (@area.width/10), (@area.height/10), @color_background, 999)
    Planet.all.each do |planet|
      if planet.habitable
        $window.draw_rect(x+(planet.x/10), planet.y/10, 10, 10, @color_planet, 999) if planet.base.nil?
        $window.draw_rect(x+(planet.x/10), planet.y/10, 10, 10, @color_planet_based, 999) unless planet.base.nil?
      else
        $window.draw_rect(x+(planet.x/10), planet.y/10, 10, 10, @color_planet_not_habitable, 999)
      end
    end
    #
    Enemy.all.each do |enemy|
      begin
        $window.draw_rect(x+(enemy.x/10), enemy.y/10, 10, 10, @color_enemy, 999)
      rescue RangeError => e
        Logger.log("#{e}", self)
      end
    end
    #
    Asteroid.all.each do |asteroid|
      $window.draw_rect(x+(asteroid.x/10), asteroid.y/10, 10, 10, @color_asteroid, 999)
    end
    #
    Ship.all.each do |ship|
      $window.draw_rect(x+(ship.x/10), ship.y/10, 10, 10, @color_ship, 999)
    end
  end
end
