module AssetManager
  def self.path
    "#{File.expand_path(File.dirname(__FILE__))}".sub('/lib/planet-wars', '')
  end

  def self.asset_pack
    if File.exists?("./assets/"+ConfigManager.config["asset_pack"]) && File.directory?("./assets/"+ConfigManager.config["asset_pack"])
      ConfigManager.config["asset_pack"]
    else
      puts "AssetPackError: Asset pack '#{ConfigManager.config["asset_pack"]}', is missing, using '#{default_asset_pack}' instead."
      default_asset_pack
    end
  end

  def self.default_asset_pack
    'default'
  end

  def self.asset_packs
    Dir.glob("./assets/*")
  end
  def self.portal_path
    "./assets/#{asset_pack}/portal"
  end
  def self.ships_path
    "./assets/#{asset_pack}/ships"
  end
  def self.enemies_path
    "./assets/#{asset_pack}/enemies"
  end
  def self.planets_path
    "./assets/#{asset_pack}/planets"
  end
  def self.particles_path
    "./assets/#{asset_pack}/particles"
  end
  def self.asteroids_path
    "./assets/#{asset_pack}/asteroids"
  end
  def self.bullets_path
    "./assets/#{asset_pack}/bullets"
  end
  def self.background_path
    "./assets/#{asset_pack}/backgrounds"
  end
  def self.music_path
    "./assets/#{asset_pack}/music"
  end
  def self.sounds_path
    "./assets/#{asset_pack}/sounds"
  end
  def self.fonts_path
    "./assets/#{asset_pack}/fonts"
  end

  def self.credits_data
    @credits_data = Psych.load_file("#{path}/assets/#{asset_pack}/data/credits.yml") unless defined?(@credits_data)
    @credits_data
  end

  def self.theme_data
    @theme_data = Psych.load_file("#{path}/assets/#{asset_pack}/data/theme.yml") unless defined?(@theme_data)
    @theme_data
  end

  def self.theme_color(named_color)
    color = Chroma.paint(named_color).rgb
    return Gosu::Color.rgb(color.r, color.g, color.b)
  end

  def self.preload_assets
    credits_data
    images = []
    music  = []

    [portal_path, particles_path, ships_path, enemies_path, planets_path, bullets_path, music_path].each do |asset|
      Dir["#{asset}/*.png"].each do |image|
        images << image if image.end_with?('.png')
      end
      Dir["#{asset}/*.ogg"].each do |song|
        music << song if song.end_with?('.ogg')
      end
    end

    images.each do |i|
      Gosu::Image[i]
    end

    music.each do |song|
      Gosu::Song[song]
    end
  end
end
