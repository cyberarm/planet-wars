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

  # Achievement checks
  def game_time
    GameHUD.instance.clock_time
  end

  def kill_count
    GameInfo::Kills.kills
  end

  def base_count
    Base.all.count
  end

  def repair_count
    GameInfo::Config.repairs
  end
end

class AchievementManager < GameObject
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
    AssetManager.get_sample("#{AssetManager.sounds_path}/achievement_unlocked.ogg").play if ConfigManager.config["sounds"]
  end
end
