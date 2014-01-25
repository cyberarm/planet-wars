class FiftyKills < Achievement
  def initialize
    @achieved = false
  end

  def check
    if !@achieved && kill_count >= 50
      @achieved = true
      true
    else
      false
    end
  end

  def message
    "50 Kills. kill 50 enemies."
  end

  def points
    20
  end

  def kill_count
    GameInfo::Config.kills
  end
end