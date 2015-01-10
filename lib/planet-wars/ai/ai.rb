# AI for Enemies and Friendly's
# states: [:attack, retreat, heal, seek]

class AI
  attr_accessor :game_object, :machine
  def initialize(game_object)
    @game_object = game_object
    setup
  end

  def setup
    raise "#{self.class}#setup is not defined."
  end
end
