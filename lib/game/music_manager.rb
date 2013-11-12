class MusicManager < Chingu::GameObject # Broken
  attr_accessor :song, :list

  def setup
    @limiter = 0
    @music = Dir["#{AssetManager.music_path}/*.ogg"]
    @list  = @music
    10.times{@music.shuffle!}
    @current = 0
    @toggle = true
    @song = Gosu::Song[(@music[@current])]
    @song.play
  end

  def update
    if @limiter >= 60*3
      if  @song.playing? == false && @song.paused? == false
        @current += 1
        if @current >= @music.count
          @current = 0
        end
  
        @song = Gosu::Song[(@music[@current])]
        @song.play
      end
    end

    @limiter= 0 if @limiter >= 60*3
    @limiter+=1
  end

  def toggle
    if @toggle
      @song.pause
      @toggle = false
    else
      @song.play
      @toggle = true
    end
  end

  def destroy
    @song.stop
    super
  end
end