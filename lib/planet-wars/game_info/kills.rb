class GameInfo
   module Kills
     def self.kills
       @kills = 0 unless defined?(@kills)
       @kills
     end

     def self.killed
       kills
       @kills+=1
     end

     def self.reset
       @kills=0
     end
   end
end