class Enemy < Chingu::GameObject
  attr_reader :health
  attr_accessor :marked, :move, :health
  trait :effect
  trait :timer
  trait :bounding_circle
  trait :collision_detection
  def setup
    self.zorder = 200
    @marked= false
    @speed = 2
    @health= 40
    @dead  = false
    @image = Gosu::Image["#{AssetManager.ships_path}/enemy.png"]
    @particle_img = TexPlay.create_image($window, 10, 10, color: :yellow)
    @particle=Ashton::ParticleEmitter.new(self.x, self.y, 199, image: @particle_img, scale: 1.0,speed: 100,friction: 0.1,max_particles: 300,interval: 0.003,fade: 100,angular_velocity: -200..200)
    @target_area = TargetArea.create(owner: self)
    @dx = 0
    @dy = 0
    every(1000) do
      Bullet.create(x: self.x, y: self.y, z: 199, created_by_enemy: true, velocity_x: @dx*3, velocity_y: @dy*3) if @target_area.in_range
    end
  end

  def draw
    super
    @particle.draw if @dead
  end

  def update
    if @dead
      @last_update_at ||= Gosu::milliseconds
      @particle.update ([Gosu::milliseconds - @last_update_at, 100].min * 0.001)
      @last_update_at = Gosu::milliseconds
      @particle.x = self.x
      @particle.y = self.y
    end

    unless @dead
      rotate(rand(0.0..1.0))
      if defined?(@ship)
        @dx = @ship.x - self.x
        @dy = @ship.y - self.y
        length = Math.sqrt( @dx*@dx + @dy*@dy )
        @dx /= length; @dy /= length
        @dx *= @speed; @dy *= @speed
        self.x += @dx
        self.y += @dy
      else
        @ship  = Ship.all.first
      end
      @marked = false
    end

    check_health
  end

  def check_health
    if @health <= 0
      self.die
    end
  end

  def die
    @dead = true
    @target_area.destroy
    self.scale = 0.0
    after(1000) {self.destroy}
  end

  def hit
    @health-=10
  end

  def self.spawn(portal)
    Enemy.create(x: portal.x, y: portal.y)
  end
end