require "chingu"
require "ashton"
require "securerandom"
require "texplay"
require "time"

require_all "lib/planet-wars/errors"

require_relative "lib/planet-wars/version"
require_relative "lib/planet-wars/asset_manager"
require_relative "lib/planet-wars/config_manager"

# require_relative "lib/planet-wars/net/server/config"
# require "gameoverseer"
# require_relative "lib/planet-wars/net/net_client"
# require_relative "lib/planet-wars/net/net_server"

require_relative "lib/planet-wars/gameui/gameui"

require_relative "lib/planet-wars/game/engine"
require_relative "lib/planet-wars/game/achievement_manager"
require_relative "lib/planet-wars/game/hazard_manager"
require_relative "lib/planet-wars/game/music_manager"
require_relative "lib/planet-wars/game/name_gen"
require_relative "lib/planet-wars/game/world_gen"
require_relative "lib/planet-wars/game/minimap_gen"

require_all "lib/planet-wars/objects"

require_all "lib/planet-wars/game/achievements"

require_all "lib/planet-wars/game/state/helpers"

require_relative "lib/planet-wars/game/state/confirm"
require_relative "lib/planet-wars/game/state/boot"
require_relative "lib/planet-wars/game/state/credits"
require_relative "lib/planet-wars/game/state/mainmenu"
require_relative "lib/planet-wars/game/state/multiplayer_menu"
require_relative "lib/planet-wars/game/state/settings_menu"
require_relative "lib/planet-wars/game/state/mode_menu"
require_relative "lib/planet-wars/game/state/game"
require_relative "lib/planet-wars/game/state/netgame"
require_relative "lib/planet-wars/game/state/gameover"
require_relative "lib/planet-wars/game/state/planet_view"

Thread.abort_on_exception = true
Gosu::enable_undocumented_retrofication
puts "-"

begin
  build = Integer(open("#{Dir.pwd}/lib/planet-wars/dev_stats/build.dat").read)
  build += 1
  open("#{Dir.pwd}/lib/planet-wars/dev_stats/build.dat", 'w') do |file|
    file.write build
  end
  BUILD = build
rescue => e
  puts e
  open("#{Dir.pwd}/lib/planet-wars/dev_stats/build.dat", 'w') do |file|
    BUILD = 0
    file.write BUILD
  end
end
if ARGV.join.include?('--debug')
  at_exit do
    puts "==== Garbage Collection Stats ===="
    GC.stat.each do |key, value|
      puts "#{key}: #{value}"
    end
  end
end

begin
  Engine.new.show
rescue => e
  require "pry"
  puts e
  puts e.backtrace
  binding.pry
end