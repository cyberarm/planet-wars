class SupremeEmperor < Achievement
  def initialize
    @achieved = false
  end

  def check
    if !@achieved && base_count >= 25
      @achieved = true
      true
    else
      false
    end
  end

  def message
    "Supreme Emperor. Build 25 bases."
  end

  def points
    25
  end
end
