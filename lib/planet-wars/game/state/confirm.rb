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
      push_game_state(previous_game_state, setup: false)
    end
  end

  def draw
    super
    previous_game_state.draw
  end
end