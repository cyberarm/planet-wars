class Confirm < GameUI
  def initialize(options={})
    @string = options[:text]
    options[:title] = @string
    super
    button "Yes", tooltip: "Exit to Main Menu" do 
      push_game_state(MainMenu)
    end
    button "No", tooltip: "Return to Game" do
      push_game_state(previous_game_state, setup: false)
    end
  end

end