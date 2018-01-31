class Confirm < GameUI
  def initialize(options={})
    @string = options[:text]
    options[:title] = @string
    super
    button "Yes", tooltip: "Exit to Main Menu" do
      options[:block].call if options[:block]
      push_game_state(MainMenu) unless options[:block]
    end
    button "No", tooltip: "Return to Game" do
      $window.show_cursor = false
      push_game_state(options[:state], setup: false)
    end
  end

  def draw
    super
  end
end
