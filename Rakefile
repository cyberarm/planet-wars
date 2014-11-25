require "ocra"
require "releasy"
require 'bundler/setup' # Releasy requires require that your application uses bundler.
require_relative "lib/planet-wars/version"

task :profile do
  `ruby-prof planet-wars.rb -p graph_html -f lib/planet-wars/dev_stats/ruby-prof.html`
end


Releasy::Project.new do
  name GameInfo::NAME
  version "#{GameInfo::VERSION}-#{File.open("lib/planet-wars/dev_stats/build.dat").read}"
  verbose # Can be removed if you don't want to see all build messages.

  executable "planet-wars.rb"
  files ["lib/**/*.*", "assets/**/*.*"]
  exclude_encoding # Applications that don't use advanced encoding (e.g. Japanese characters) can save build size with this.

  add_build :windows_folder do
    icon "assets/icon.ico"
    # executable_type :windows # Assuming you don't want it to run with a console window.
    add_package :exe # Windows self-extracting archive.
  end

  # add_deploy :local # Only deploy locally.
end
