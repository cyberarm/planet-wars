class MainMenu < GameUI
  trait :timer
  def initialize(options={})
    $music_manager.song.pause if defined?($music_manager) # Can not figure out why music starts playing here when it is paused...
    options[:title] = "#{GameInfo::NAME}"
    super

    button("Single Player", tooltip: "play the game") do
      push_game_state(ModeMenu)
    end

    button("Multiplayer", tooltip: "Play with an AI or a person") do
      push_game_state(MultiPlayerMenu)
    end

    button("Settings", tooltip: "Configure game") do
      push_game_state(SettingsMenu)
    end

    button("Credits", tooltip: "Find out who helped build this game") do
      push_game_state(Credits)
    end

    button("Exit", tooltip: "Quit game") do
      exit
    end

    if $latest_release_data
      @message_l= Text.new("Update Available!", x: 100, y: $window.height-140, z: 100, size: 20)
      @message_l2= Text.new("Version '#{$latest_release_data['name']}' available, you're currently on '#{GameInfo::VERSION}'.", x: 100, y: $window.height-110, z: 100, size: 18)
      @image_l = Gosu::Image["assets/kenney_gameicons/import.png"]
    end
  end

  def draw
    super
    if $latest_release_data
      @message_l.draw
      @message_l2.draw
      fill_rect([100+16, $window.height-100+16, 70, 70], Gosu::Color::WHITE, 9)
      @image_l.draw(100,$window.height-100,10)
    end
  end
end
