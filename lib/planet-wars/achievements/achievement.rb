class Achievement
  def initialize(text, points)
    @text = text
    @points = points
  end

  def check_if_achieved
    raise "Undefined 'check_if_achieved' in #{self.class} is undefined!"
  end
end