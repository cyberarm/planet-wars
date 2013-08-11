require "chingu"
require "stringio"
require "ruby-prof"
require "texplay"
require "set"

require_relative "lib/version"

require_relative "lib/game/engine"
require_relative "lib/game/notifications"
require_relative "lib/game/music_manager"
require_relative "lib/game/name_gen"
require_relative "lib/game/world_gen"
require_relative "lib/game/minimap_gen"

require_relative "lib/game/state/game"
require_relative "lib/game/state/upgrade_ship"
require_relative "lib/game/state/planet_view"

require_relative "lib/objects/planet"
require_relative "lib/objects/ship"
require_relative "lib/objects/minimap"

Thread.abort_on_exception = true

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

# result = RubyProf.profile do |prof|
#   prof.eliminate_methods!([/Integer#times/])
#   prof.eliminate_methods!([/Array#each/])
#   prof.eliminate_methods!([/Kernel#loop/])
#   prof.eliminate_methods!([/Kernel#sleep/])
#   prof.eliminate_methods!([/Class#new/])
#   game = Thread.new do
    Engine.new.show
#   end
#   game.join
# end

printer = RubyProf::GraphHtmlPrinter.new(result)
printer.print(File.open("#{Dir.pwd}/lib/dev_stats/ruby-prof.html", 'w'))