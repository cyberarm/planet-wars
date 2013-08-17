module AssetManager
  def self.ships_path
    "./assets/ships"
  end
  def self.planets_path
    "./assets/planets"
  end
  def self.bullets_path
    "./assets/bullets"
  end
  def self.music_path
    "./assets/music"
  end
  def self.fonts_path
    "./assets/fonts"
  end

  def self.credits_data
    @credits_data
  end

  def self.preload_assets
    @credits_data = YAML.load_file("./assets/data/credits.yml")
    images = []
    music  = []
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