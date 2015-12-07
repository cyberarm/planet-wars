class Birdman < Achievement
  def initialize
    @achieved = false
  end

  def check
    if !@achieved && game_time >= 60*10
      @achieved = true
      true
    else
      false
    end
  end

  def message
    "Birdman. Survive for 10 minutes."
  end

  def points
    25
  end
end
