# AI for Enemies and Friendly's
# states: [:attack, retreat, heal, seek]

class AI
  attr_accessor :game_object, :state
  def initialize(game_object)
    @game_object = game_object
    @state = :nil
    setup
  end

  def setup
    raise "#{self.class}#setup is not defined."
  end

  def move(object)
    # TODO: Flock behavior

    game_object.dx = object.x - game_object.x
    game_object.dy = object.y - game_object.y

    length = Math.sqrt( game_object.dx*game_object.dx + game_object.dy*game_object.dy )
    game_object.dx /= length; game_object.dy /= length

    game_object.dx *= game_object.speed
    game_object.dy *= game_object.speed

    game_object.x += game_object.dx
    game_object.y += game_object.dy
  end
end
