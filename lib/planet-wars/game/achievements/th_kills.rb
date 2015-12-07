class THKills < Achievement
  def initialize
    @achieved = false
  end

  def check
    if !@achieved && kill_count >= 250
      @achieved = true
      true
    else
      false
    end
  end

  def message
    "250 Kills. kill 250 enemies."
  end

  def points
    25
  end
end
