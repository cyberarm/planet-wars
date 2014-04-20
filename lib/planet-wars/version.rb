class GameInfo
  VERSION = "BETA"
  NAME    = "Planet Wars"
  module Config
    def self.kills
      @kills = 0 unless defined?(@kills)
      @kills
    end

    def self.killed
      kills
      @kills+=1
    end

    def self.repairs
      @repairs = 0 unless defined?(@repairs)
      @repairs
    end

    def self.repaired
      repairs
      @repairs+=1
    end

     def self.bullets_fired
      @bullets = 0 unless defined?(@bullets)
      @bullets
    end

    def self.bullet_shot
      bullets_fired
      @bullets+=1
    end

    def self.game_time
      @time = Time.now unless defined?(@time)
      return @time
    end

    def self.game_time=(i)
      @time = i
      return @time
    end

    def self.game_time_processed
      @game_time_processed = Time.now unless defined?(@game_time_processed)
      return @game_time_processed
    end

    def self.game_time_processed=(i)
      @game_time_processed = i
      return @game_time_processed
    end

    def self.number_of_enemies
      @number = 3 unless defined?(@number)
      @number
    end

    def self.number_of_enemies=(i)
      @number = i
    end

    def self.number_of_portals
      @portals = 1 unless defined?(@portals)
      @portals
    end

    def self.number_of_portals=(i)
      @portals = i
    end
  end
end