class MusicManager < GameObject
  attr_accessor :song, :list

  def setup
    @limiter = 0
    @music_data = AssetManager.credits_data['credits']['music']
    @music = Dir["#{AssetManager.music_path}/*.ogg"]
    @list  = @music
    10.times{@music.shuffle!}
    @current = 0
    @toggle = true
    @song = AssetManager.get_song(@music[@current])
    if play_songs?
      @song.play
      NotificationManager.add("Now playing: #{title}, by: #{composer}") rescue NoMethodError
    end
  end

  def update
    if @limiter >= 120
      if !@song.playing? && !@song.paused?
        @current += 1
        if @current >= @music.count-1
          @current = 0
        end

        @song = Gosu::Song[(@music[@current])]

        if play_songs?
          @song.play
          NotificationManager.add("Now playing: #{title}, by: #{composer}") rescue NoMethodError
        end
      end
    end

    @limiter= 0 if @limiter >= 120
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

  def title
    @music_data.select do |song|
      if @music[@current].downcase.include?(song['name'].downcase)
        return song['name']
      end
    end
  end

  def composer
    @music_data.select do |song|
      if @music[@current].downcase.include?(song['name'].downcase)
        return song['composer']
      end
    end
  end

  def play_songs?
    ConfigManager.config["music"]
  end

  def destroy
    @song.stop
    super
  end
end
