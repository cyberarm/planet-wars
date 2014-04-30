class Enemy < Chingu::GameObject
  attr_reader :health
  attr_accessor :move, :health
  trait :effect
  trait :bounding_circle
  trait :collision_detection
  def setup
    self.zorder = 200
    self.alpha = 0
    @speed = 2
    @health= 40
    @image = Gosu::Image["#{AssetManager.ships_path}/enemy.png"]
    @target = Target.create(x: 0, y: 0) unless Target.all.first.is_a?(Target)
    @target = Target.all.first if Target.all.first.is_a?(Target)
    @target_area = TargetArea.create(owner: self, target: @target, size: 255.0)
    @tick = 0
    @dx = 0
    @dy = 0
  end

  def update
    self.alpha+=2
    rotate(rand(0.0..1.0))
    if defined?(@target_area) && self.alpha >= 255 #&& @target_area.in_range
      @dx = @target.x - self.x
      @dy = @target.y - self.y
      length = Math.sqrt( @dx*@dx + @dy*@dy )
      @dx /= length; @dy /= length
      @dx *= @speed; @dy *= @speed
      self.x += @dx
      self.y += @dy
    end

    if @tick >= 60
      @tick = 0
      Bullet.create(x: self.x, y: self.y, z: 199, velocity_x: @dx*3, velocity_y: @dy*3) if @target_area.in_range && self.alpha >= 255
    end

    @tick+=1
    check_health
  end

  def check_health
    if @health <= 0
      Empty.create(x: self.x, y: self.y)
      Gosu::Sample["#{AssetManager.sounds_path}/explosion.ogg"].play if ConfigManager.config["sounds"]
      GameInfo::Kills.killed if @object.is_a?(Bullet)
      self.destroy
    end
  end

  def hit(damage, object)
    @object = object
    @health-=damage if self.alpha >= 255
  end

  def destroy
    super
    @target_area.destroy
  end

  def self.spawn(portal)
    Enemy.create(x: portal.x, y: portal.y)
  end
end