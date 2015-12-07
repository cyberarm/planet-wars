class Flyer < Achievement
  def initialize
    @achieved = false
  end

  def check
    if !@achieved && game_time >= 60*7
      @achieved = true
      true
    else
      false
    end
  end

  def message
    "Flyer. Survive for 7 minutes."
  end

  def points
    25
  end
end
