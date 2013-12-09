class Portal < Chingu::GameObject
  trait :timer
  trait :effect

  def setup
    @image = Gosu::Image["#{AssetManager.portal_path}/portal.png"]
    self.alpha = 0
    every(1500) do
      Enemy.spawn(self) if @ready && Enemy.all.count <= GameInfo::Config.number_of_enemies
    end

    every(4000) do
      if self.alpha <= 0
        self.x = rand(100..@options[:world_width]-100)
        self.y = rand(100..@options[:world_height]-100)
      end
    end
  end

  def draw
    super
  end

  def update
    if @ready
      fade_out(3) unless @spawn
      fade_in(3) if @spawn
    end

    if Time.now-GameInfo::Config.game_time > 10
      @ready = true
    end

    @spawn = true if self.alpha <= 255 && Enemy.all.count <= GameInfo::Config.number_of_enemies
    @spawn = false unless Enemy.all.count <= GameInfo::Config.number_of_enemies

    self.scale = 2.0
  end
end