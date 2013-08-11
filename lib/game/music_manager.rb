class MusicManager
  attr_accessor :stop, :current, :music
  def initialize
    @music = Dir["#{Dir.pwd}/music/*.ogg"]
    p @music
    @current = 0
    @stop = false
    play
  end

  def play
    Thread.new do
      @playing = Gosu::Sample.new(@music[@current]).play
      puts "playing: #{File.basename(@music[@current])}"

      loop do
        sleep 1
        if @playing.playing? == false
          @current += 1
          if @current >= @music.count
            @current = 0
          end
          unless @stop
            @playing = Gosu::Sample.new(@music[@current]).play
            puts "playing: #{File.basename(@music[@current])}"
          end
        end
      end
    end
  end
end