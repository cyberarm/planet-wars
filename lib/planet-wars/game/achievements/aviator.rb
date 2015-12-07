class Aviator < Achievement
  def initialize
    @achieved = false
  end

  def check
    if !@achieved && game_time >= 60*5
      @achieved = true
      true
    else
      false
    end
  end

  def message
    "Aviator. Survive for 5 minutes."
  end

  def points
    25
  end
end
