class OHKills < Achievement
  def initialize
    @achieved = false
  end

  def check
    if !@achieved && kill_count >= 100
      @achieved = true
      true
    else
      false
    end
  end

  def message
    "100 Kills. kill 100 enemies."
  end

  def points
    25
  end

  def kill_count
    GameInfo::Config.kills
  end
end