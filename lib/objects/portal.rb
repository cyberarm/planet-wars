class Portal < Chingu::GameObject
  trait :timer
  trait :effect

  def setup
    @image = Gosu::Image["#{AssetManager.portal_path}/portal.png"]
    self.alpha = 0
    every(1500) do
      Enemy.spawn(self) if Enemy.all.count <= 3
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
    fade_out(3) unless @spawn
    fade_in(3) if @spawn

    @spawn = true if Enemy.all.count <= 3
    @spawn = false unless Enemy.all.count <= 3

    self.scale = 2.0
  end
end