class Pilot < Achievement
  def initialize
    @achieved = false
  end

  def check
    if !@achieved && game_time >= 120
      @achieved = true
      true
    else
      false
    end
  end

  def message
    "Pilot. Survive for 2 minutes."
  end

  def points
    20
  end
end
