class Pilot < Achievement
  def initialize
    @achieved = false
  end

  def check
    if !@achieved && Time.now-game_time >= 120
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

  def game_time
    GameInfo::Config.game_time
  end
end