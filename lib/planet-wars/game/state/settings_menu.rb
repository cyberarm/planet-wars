class SettingsMenu < GameUI
  def initialize options={}
    options[:title] = "#{GameInfo::NAME}//Settings"
    super

    button("Music", tooltip: "Play/Stop music (#{if ConfigManager.config["music"]; 'ON';else 'OFF';end})") do
      if ConfigManager.config["music"]
        ConfigManager.update("music", false)
        selected[:tooltip] = "Music is OFF"
      else
        ConfigManager.update("music", true)
        selected[:tooltip] = "Music is ON"
      end
    end

    button("Sound", tooltip: "Enable/Disable sound effects (#{if ConfigManager.config["sounds"]; 'ON';else 'OFF';end})") do
      if ConfigManager.config["sounds"]
        ConfigManager.update("sounds", false)
        selected[:tooltip] = "sound effects are OFF"
      else
        ConfigManager.update("sounds", true)
        selected[:tooltip] = "sound effects are ON"
      end
    end

    button("Hazards", tooltip: "Enable/Disable hazards (#{if ConfigManager.config["hazards"]; 'ON';else 'OFF';end})") do
      if ConfigManager.config["hazards"]
        ConfigManager.update("hazards", false)
        selected[:tooltip] = "Hazards are OFF"
      else
        ConfigManager.update("hazards", true)
        selected[:tooltip] = "Hazards are ON"
      end
    end

    button("Back"){push_game_state(MainMenu)}
  end
end