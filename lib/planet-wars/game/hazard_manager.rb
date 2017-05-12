class HazardManager < Chingu::GameObject
  def setup
    @hazards = [Asteroid]
    @tick = 0
  end

  def update
    @tick+=1
    if @tick >= 60*30
      if ConfigManager.config["hazards"]
        create_hazard
        Gosu::Sample["#{AssetManager.sounds_path}/incoming_asteroids.ogg"].play if ConfigManager.play_sounds?
      end

      @tick = 0
    end
  end

  def create_hazard
    rand(1..5).times do
      num = rand(1..@hazards.count)
      @hazards[num-1].create
    end
  end
end
