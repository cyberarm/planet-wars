class TheBuilder < Achievement
  def initialize
    @achieved = false
  end

  def check
    if !@achieved && base_count >= 10
      @achieved = true
      true
    else
      false
    end
  end

  def message
    "The Builder. Build 10 bases."
  end

  def points
    20
  end
end
