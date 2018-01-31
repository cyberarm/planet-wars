module AssetManager
  IMAGE_CACHE = {}
  SONG_CACHE  = {}
  SAMPLE_CACHE= {}

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
    array = []
    Dir.glob("./assets/*").each do |d|
      if File.exist?("#{d}/data/theme.yml") && File.exist?("#{d}/data/credits.yml")
        array.push(d)
      end
    end
    array
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

  def self.update_theme_data
    @theme_data = Psych.load_file("#{path}/assets/#{asset_pack}/data/theme.yml")
  end

  def self.theme_color(named_color, alpha=255)
    color = Chroma.paint(named_color).rgb
    return Gosu::Color.rgba(color.r, color.g, color.b, alpha)
  end

  def self.theme_color_inverse(named_color, alpha=255)
    case
    when Chroma.paint(named_color).dark?
      color = Chroma.paint(named_color).lighten(80).rgb
    when Chroma.paint(named_color).light?
      color = Chroma.paint(named_color).darken(80).rgb
    end
    return Gosu::Color.rgba(color.r, color.g, color.b, alpha)
  end

  def self.preload_assets
    credits_data
    images = []
    music  = []
    samples= []

    [background_path, portal_path, particles_path, ships_path, enemies_path, planets_path+"/uninhabitable", planets_path+"/habitable", bullets_path, music_path].each do |asset|
      Dir["#{asset}/*.png"].each do |image|
        images << image if image.end_with?('.png')
      end
      Dir["#{asset}/*.ogg"].each do |song|
        music << song if song.end_with?('.ogg')
      end
    end
    Dir["#{sounds_path}/**/*.ogg"].each do |sample|
      samples << sample if sample.end_with?('.ogg')
    end

    images.each do |i|
      cache_image(i)
    end

    music.each do |song|
      cache_song(song)
    end

    samples.each do |sample|
      cache_sample(sample)
    end
  end

  def self.get_image(i)
    r = IMAGE_CACHE[i]
    return r if r
    raise "Image '#{i}' not in Cache" if !r
  end

  def self.get_song(s)
    r = SONG_CACHE[s]
    return r if r
    raise "Song '#{s}' not in Cache" if !r
  end

  def self.get_sample(s)
    r = SAMPLE_CACHE[s]
    return r if r
    raise "Sample '#{s}' not in Cache" if !r
  end

  def self.cache_image(i)
    if IMAGE_CACHE[i] == nil
      IMAGE_CACHE[i] = Gosu::Image.new(i)
    end
  end

  def self.cache_song(s)
    if SONG_CACHE[s] == nil
      SONG_CACHE[s] = Gosu::Song.new(s)
    end
  end

  def self.cache_sample(s)
    if SAMPLE_CACHE[s] == nil
      SAMPLE_CACHE[s] = Gosu::Sample.new(s)
    end
  end
end
