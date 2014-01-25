class FirstKill < Achievement
  def initialize
    @achieved = false
  end

  def check
    if !@achieved && kill_count >= 1
      @achieved = true
      true
    else
      false
    end
  end

  def message
    "First Kill. kill 1 enemy."
  end

  def points
    10
  end

  def kill_count
    GameInfo::Config.kills
  end
end