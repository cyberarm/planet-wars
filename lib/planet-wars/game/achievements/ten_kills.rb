class TenKills < Achievement
  def initialize
    @achieved = false
  end

  def check
    if !@achieved && kill_count >= 10
      @achieved = true
      true
    else
      false
    end
  end

  def message
    "10 Kills. kill 10 enemies."
  end

  def points
    10
  end

  def kill_count
    GameInfo::Config.kills
  end
end