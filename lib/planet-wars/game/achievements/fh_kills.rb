class FHKills < Achievement
  def initialize
    @achieved = false
  end

  def check
    if !@achieved && kill_count >= 500
      @achieved = true
      true
    else
      false
    end
  end

  def message
    "500 Kills. kill 500 enemies."
  end

  def points
    25
  end

  def kill_count
    GameInfo::Kills.kills
  end
end