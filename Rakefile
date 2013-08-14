  require "releasy"
  require 'bundler/setup' # Releasy requires require that your application uses bundler.

  Releasy::Project.new do
    name "Planet Wars (Working Title)"
    version "1.0.1"
    verbose # Can be removed if you don't want to see all build messages.

    executable "planet-wars.rb"
    files ["lib/**/*.*", "planets/*.png", "ships/*.png", "music/*.*", "fonts/*.*"]
    exclude_encoding # Applications that don't use advanced encoding (e.g. Japanese characters) can save build size with this.

    add_build :windows_folder do
      # icon "media/icon.ico"
      # executable_type :windows # Assuming you don't want it to run with a console window.
      add_package :exe # Windows self-extracting archive.
    end

    add_deploy :local # Only deploy locally.
  end