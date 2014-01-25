class EmpireBuilding < Achievement
  def initialize
    @achieved = false
  end

  def check
    if !@achieved && base_count >= 1
      @achieved = true
      true
    else
      false
    end
  end

  def message
    "Empire Building. Build a base." # Achievement unlocked: build a base.
  end

  def points
    10
  end

  def base_count
    Base.all.count
  end
end