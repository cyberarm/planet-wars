require "chingu"
require "set"

require_relative "lib/version"
# require_relative "lib/set_addons"

require_relative "lib/game/engine"
require_relative "lib/game/game"
require_relative "lib/game/notifications"
require_relative "lib/game/name_gen"
require_relative "lib/game/world_gen"

require_relative "lib/objects/planet"
require_relative "lib/objects/ship"

begin
  build = Integer(open("#{Dir.pwd}/lib/dev_stats/build.dat").read)
  build += 1
  open("#{Dir.pwd}/lib/dev_stats/build.dat", 'w') do |file|
    file.write build
  end
  BUILD = build
rescue => e
  puts e
  open("#{Dir.pwd}/lib/dev_stats/build.dat", 'w') do |file|
    BUILD = 0
    file.write BUILD
  end
end

Engine.new.show