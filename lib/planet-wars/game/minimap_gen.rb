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
    @image   = TexPlay.create_image($window, area[0]/100, area[1]/100, color: @color_background)

    generate_image
    return @image
  end

  def background_color(color)
    color = Chroma.paint(color).rgb
    return Gosu::Color.rgba(color.r, color.g, color.b, 100)
  end

  def generate_image
    @planets.each do |planet|
      if planet.habitable
        @image.pixel(planet.x/100, planet.y/100, color: @color_planet) if planet.base.nil?
        @image.pixel(planet.x/100, planet.y/100, color: @color_planet_based) unless planet.base.nil?
      else
        @image.pixel(planet.x/100, planet.y/100, color: @color_planet_not_habitable)
      end
    end

    @enemies.each do |enemy|
      begin
        @image.pixel(enemy.x/100, enemy.y/100, color: @color_enemy)
      rescue RangeError => e
        Logger.log("#{e}", self)
      end
    end

    @asteroids.each do |asteroid|
      @image.pixel(asteroid.x/100, asteroid.y/100, color: @color_asteroid)
    end

    @ships.each do |ship|
      @image.pixel(ship.x/100, ship.y/100, color: @color_ship)
    end
  end
end
