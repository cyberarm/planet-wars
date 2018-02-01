module ConfigManager
  def self.config
    refresh_config unless defined?(@config_data)
    @config_data["config"]
  end

  def self.refresh_config
    begin
      @config_data = Psych.load_file("./lib/planet-wars/game/data/config.yml")
      if @config_data.is_a?(Hash)
        return @config_data["config"]
      else
        raise BadConfigurationError, "Missing or corrupted configuration file."
      end
    end
  end

  def self.update(option, value)
    unless @config_data["config"][option] == value
      @config_data["config"][option] = value
      yaml = Psych.dump(@config_data)
      unless yaml == ""
        File.open("./lib/planet-wars/game/data/config.yml", "w") do |file|
           file.write(yaml)
        end
      end
      refresh_config unless yaml == ""
    end
  end

  def self.play_sounds?
    if $mute
      false
    else
      @config_data['config']['sounds']
    end
  end

  def self.play_music?
    if $mute
      false
    else
      @config_data['config']['music']
    end
  end

  def self.enable_hazards?
    @config_data['config']['hazards']
  end

  def self.fullscreen?
    @config_data['screen']['fullscreen']
  end

  def self.screen_width
    @config_data['screen']['width']
  end

  def self.screen_height
    @config_data['screen']['height']
  end
end
