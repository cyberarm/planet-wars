module ConfigManager
  def self.config
    unless defined?(@config_data)
      refresh_config
    end
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
end