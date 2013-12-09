class Empty < Chingu::GameObject
  def setup
    self.zorder = 299
    @particle_img = TexPlay.create_image($window, 4, 4, color: :yellow)
    @particle_color = 255
    @particle=Ashton::ParticleEmitter.new(self.x, self.y,
      199, image: @particle_img, scale: 1.0,speed: 100,
      friction: 0.1,max_particles: 300,interval: 0.003,fade: 100,angular_velocity: 0.0)
  end

  def draw
    super
    @particle.draw
  end

  def update
    @last_update_at ||= Gosu::milliseconds
    @particle.update([Gosu::milliseconds - @last_update_at, 100].min * 0.001)
    @last_update_at = Gosu::milliseconds
    @particle.x = self.x
    @particle.y = self.y

    @particle.color=Gosu::Color.argb(@particle_color, 244,232,100)
    @particle_color-=3
    self.destroy if @particle_color <= -60
  end
end