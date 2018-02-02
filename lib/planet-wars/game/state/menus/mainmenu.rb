class MainMenu < GameUI
  def create
    $music_manager.song.pause if defined?($music_manager) # Can not figure out why music starts playing here when it is paused...
    set_title("#{GameInfo::NAME}")

    button("Single Player", tooltip: "play the game") do
      push_game_state(ModeMenu)
    end

    button("Multiplayer", tooltip: "Play with an AI or a person") do
      push_game_state(MultiPlayerMenu)
    end

    button("Settings", tooltip: "Configure game") do
      push_game_state(SettingsMenu)
    end

    button("Credits", tooltip: "Find out who helped make this game possible") do
      push_game_state(Credits)
    end

    button("Exit", tooltip: "Quit game") do
      exit
    end

    if $latest_release_data
      @message_l= Text.new("Update Available!", x: 100, y: $window.height-140, z: 100, size: 20)
      @message_l2= Text.new("Version '#{$latest_release_data['name']}' available, you're currently on '#{GameInfo::VERSION}'.", x: 100, y: $window.height-110, z: 100, size: 18)
      @image_l = AssetManager.get_image("./assets/kenney_gameicons/import.png")
    end

    @cx, @cy = $window.width/2, $window.height/2
    @cwidth, @cheight = $window.width/2, $window.height/2
  end

  def update
    super
    @cx-=20 unless @cx < 1
    @cy-=12 unless @cy < 1
    @cwidth+=12 unless @cwidth > $window.width
    @cheight+=20 unless @cheight > $window.height

    if $latest_release_data
      if $window.button_down?(Gosu::MsLeft)
        if $window.mouse_x.between?(100, 100+@image_l.width)
          if $window.mouse_y.between?($window.height-100, $window.height-100+@image_l.height)
            p $latest_release_data if $debug
            Launchy.open($latest_release_data["html_url"])
          end
        end
      end
    end
  end

  def draw
    $window.clip_to(@cx, @cy, @cwidth, @cheight) do
      super
      # $window.draw_rect(0,0,$window.width,$window.height,Gosu::Color::RED,1)
      if $latest_release_data && @message_l
        @message_l.draw
        @message_l2.draw
        fill_rect(100+16, $window.height-100+16, 70, 70, AssetManager.theme_color(AssetManager.theme_data["gameui"]["color"]), 9)
        @image_l.draw(100,$window.height-100,10, 1,1, AssetManager.theme_color(AssetManager.theme_data["gameui"]["button"]["active_background"]))
      end
    end
  end
end
