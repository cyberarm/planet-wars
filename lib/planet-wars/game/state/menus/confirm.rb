class Confirm < GameUI
  def create
    set_title(options[:text])

    button "Yes", tooltip: "Exit to Main Menu" do
      options[:block].call if options[:block]
      push_game_state(MainMenu) unless options[:block]
    end

    button "No", tooltip: "Return to Game" do
      $window.show_cursor = false
      push_game_state(options[:state])
    end
  end

  def go_back
    $window.show_cursor = false
    push_game_state(options[:state])
  end
end
