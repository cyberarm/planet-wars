class Empty < GameObject
  def setup
    self.z = 299
    @particle_img = AssetManager.get_image("#{AssetManager.particles_path}/explosion.png")
    @particle_emitter = ParticleEmitter.new(x: self.x, y: self.y, z: 1, max_particles: 100)
    @tick = 0
  end

  def update
    @tick+=1
    @particle_emitter.emit = false if @tick >= 80
    @particle_emitter.x = self.x
    @particle_emitter.y = self.y

    self.destroy if @tick >= 180
  end

  def destroy
    @particle_emitter.destroy
    super
  end
end
