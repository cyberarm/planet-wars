class Technician < Achievement
  def initialize
    @achieved = false
  end

  def check
    if !@achieved && repair_count >= 1
      @achieved = true
      true
    else
      false
    end
  end

  def message
    "Technician. Repair your ship once."
  end

  def points
    10
  end

  def repair_count
    GameInfo::Config.repairs
  end
end