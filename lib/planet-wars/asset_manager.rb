module AssetManager
  def self.path
    "#{File.expand_path(File.dirname(__FILE__))}".sub('/lib/planet-wars', '')
  end

  def self.process string
    string.gsub('/', "\\") if !RUBY_PLATFORM.include?('darwin') && (RUBY_PLATFORM.include?('win') || RUBY_PLATFORM.include?('mingw'))
  end

  def self.asset_pack
    if File.exists?("./assets/"+ConfigManager.config["asset_pack"]) && File.directory?("./assets/"+ConfigManager.config["asset_pack"])
      ConfigManager.config["asset_pack"]
    else
      puts "AssetPackError: Asset pack \"#{ConfigManager.config["asset_pack"]}\", is missing, using \"default\" instead."
      'default'
    end
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
  def self.planets_path
    "./assets/#{asset_pack}/planets"
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
    process("#{path}/assets/#{asset_pack}/fonts")
  end

  def self.credits_data
    @credits_data = Psych.load_file("#{path}/assets/#{asset_pack}/data/credits.yml") unless defined?(@credits_data)
    @credits_data
  end

  def self.preload_assets
    @credits_data = Psych.load_file("#{path}/assets/#{asset_pack}/data/credits.yml")
    images = []
    music  = []
    Dir[portal_path+'/*.png'].each {|image| images << image}
    Dir[ships_path+'/*.png'].each {|image| images << image}
    Dir[planets_path+'/*.png'].each {|image| images << image}
    Dir[bullets_path+'/*.png'].each {|image| images << image}
    Dir[music_path+'/*.ogg'].each {|song| music << song}

    images.each do |i|
      Gosu::Image[i]
    end

    music.each do |song|
      Gosu::Song[song]
    end
  end
end
