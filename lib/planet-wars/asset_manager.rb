module AssetManager
  def self.asset_pack
    # TODO: Add ConfigManager
    @config_data = Psych.load_file("./lib/planet-wars/game/data/config.yml")
    @config_data["config"]["asset_pack"]
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
    "./assets/#{asset_pack}/fonts"
  end

  def self.credits_data
    @credits_data = Psych.load_file("./assets/#{asset_pack}/data/credits.yml") unless defined?(@credits_data)
    @credits_data
  end

  def self.preload_assets
    @credits_data = Psych.load_file("./assets/#{asset_pack}/data/credits.yml")
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