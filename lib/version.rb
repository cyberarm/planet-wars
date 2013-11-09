class GameInfo
  VERSION = "ALPHA"
  NAME    = "Planet Wars"
  module Config
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