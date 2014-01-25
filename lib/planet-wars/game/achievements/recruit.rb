class Recruit < Achievement
  def initialize
    @achieved = false
  end

  def check
    if !@achieved && Time.now-game_time >= 60
      @achieved = true
      true
    else
      false
    end
  end

  def message
    "Recruit. Survive for 1 minute."
  end

  def points
    10
  end

  def game_time
    GameInfo::Config.game_time
  end
end