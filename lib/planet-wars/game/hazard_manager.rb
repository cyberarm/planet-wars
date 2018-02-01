class HazardManager < GameObject
  def setup
    @viewport_area = @options[:viewport_area]
    @hazards = [Asteroid]
    @tick = 0
  end

  def update
    @tick+=1
    if @tick >= 60*30
      if ConfigManager.config["hazards"]
        create_hazard
        AssetManager.get_sample("#{AssetManager.sounds_path}/incoming_asteroids.ogg").play if ConfigManager.play_sounds?
      end

      @tick = 0
    end
  end

  def create_hazard
    rand(1..5).times do
      num = rand(1..@hazards.count)
      o = @hazards[num-1].new(viewport_area: @viewport_area)
      place(o) if o.is_a?(Asteroid)
    end
  end

  def place(object)
    case rand(4)
    when 1
      object.x = 0
      object.y = 0
    when 2
      object.x = @viewport_area.width
      object.y = @viewport_area.height
    when 3
      object.x = @viewport_area.width
      object.y = 0
    when 4
      object.x = 0
      object.y = @viewport_area.height
    end
  end
end
