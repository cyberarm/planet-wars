class MusicManager < Chingu::GameObject # Broken
  trait :timer
  attr_accessor :song, :list
  def setup
    super
    @music = Dir["#{AssetManager.music_path}/*.ogg"]
    @list  = @music
    @music.shuffle!
    @current = 0
    @toggle = true
    @song = nil
    play
  end

  def update
    if @song.playing? == false && @song.paused?  == false
      @current += 1
      if @current >= @music.count
        @current = 0
      end
      begin
        @song = Gosu::Song[(@music[@current])]
        @song.play
      rescue NoMethodError => e
        puts e
      end
    end
  end

  def play
    @song = Gosu::Song[(@music[@current])]
    @song.play
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