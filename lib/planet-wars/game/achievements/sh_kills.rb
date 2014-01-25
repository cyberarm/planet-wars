class SHKills < Achievement
  def initialize
    @achieved = false
  end

  def check
    if !@achieved && kill_count >= 750
      @achieved = true
      true
    else
      false
    end
  end

  def message
    "750 Kills. kill 750 enemies."
  end

  def points
    25
  end

  def kill_count
    GameInfo::Config.kills
  end
end