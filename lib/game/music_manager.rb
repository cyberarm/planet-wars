class MusicManager
  attr_accessor :song, :music, :stop
  def initialize
    @music = Dir["#{AssetManager.music_path}/*.ogg"]
    p @music
    @current = 0
    @stop = false
    play
  end

  def play
    Thread.new do
      @song = Gosu::Sample.new(@music[@current]).play
      puts "playing: #{File.basename(@music[@current])}"

      loop do
        sleep 1
        break if @stop
        @song.stop if @stop
        if @song.paused? == false && @song.playing? == false
          @current += 1
          if @current >= @music.count
            @current = 0
          end
          begin
            @song = Gosu::Sample.new(@music[@current]).play
            puts "playing: #{File.basename(@music[@current])}"
          rescue NoMethodError => e
            puts e
          end
        end
      end
    end

    at_exit do
      @song.stop
    end
  end
end