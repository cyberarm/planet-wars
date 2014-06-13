class GameInfo
  module Mode
    def self.mode
      @mode = "survival" unless defined?(@mode)
      @mode
    end

    def self.mode=(_mode)
      @mode = _mode # survival|wave
    end

    def self.reset
      @mode = "survival"
    end

    def self.waves
      @waves ||= 1
    end
    def self.waves=(waves)
      @waves = waves
    end

    def self.current_wave
      @current_wave ||= 1
    end
    def self.current_wave=(wave)
      @current_wave = wave
    end

    def self.wave_spawned?
      @wave_spawned ||= false
    end
    def self.wave_spawned=(wave)
      @wave_spawned = wave
    end

    def self.wave_enemies_spawned
      @wave_enemies_spawned ||= 0
    end
    def self.wave_enemies_spawned=(wave)
      @wave_enemies_spawned = wave
    end
  end
end