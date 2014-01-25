class Achievement
  ACHIEVEMENTS = []
  def self.inherited(subclass)
    ACHIEVEMENTS << subclass.new
  end

  def self.list
    ACHIEVEMENTS
  end

  def achieved?
    if self.check
      true
    else
      false
    end
  end
end

class AchievementManager < Chingu::GameObject
  def setup
    @array = Achievement.list
  end

  def update
    @array.each do |achievement|
      if achievement.achieved?
        passed(achievement)
      end
    end
  end

  def passed(achievement)
    NotificationManager.add("Achievement Unlocked: #{achievement.message.capitalize}", Gosu::Color::GREEN, 300)
  end
end