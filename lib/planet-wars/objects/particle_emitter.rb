class ParticleEmitter < Chingu::GameObject
  attr_accessor :emit, :particle_image

  class Particle
    attr_accessor :image, :x, :y, :z, :alpha, :direction, :speed, :decay
    def initialize(image, x = 0, y = 0, z = 0, alpha = 255, direction = 0, speed = 1, decay = 1)
      @image = image
      @x, @y, @z = x, y, z
      @alpha = alpha
      @direction = direction
      @speed = speed
      @decay = decay
    end

    def draw
      @image.draw(@x, @y, @z, 1, 1, Gosu::Color.rgba(255,255,255, @alpha))
    end
  end

  def setup
    @particles = []
    @max_particles = @options[:max_particles]
    @particle_speed= 100
    @particle_decay=2.5
    @particles_per_second = 1000
    @time = 0
    @direction = 0
    @emit = true

    @particle_image = Gosu::Image[AssetManager.particles_path+"/particle.png"]
  end

  def draw
    @particles.each(&:draw)
  end

  def update
    @particles.each do |p|
      animate(p)
      @particles.delete(p) if p.alpha <= 0
    end

    if @emit && Engine.dt-@time <= (@particles_per_second/1000.0)
      create_particle
      @time = 0
    else
      @time+=Engine.dt
      # puts "time:#{@time}\\mS:#{@particles_per_second/1000.0}"
    end
  end

  def animate(particle)
    particle.alpha-=particle.decay
    it = particle.direction * (Math::PI / 180.0)
    particle.x+=(particle.speed*Engine.dt)*Math.cos(it)
    particle.y+=(particle.speed*Engine.dt)*Math.sin(it)
  end

  def create_particle
    @direction+=15*Math::PI
    # @direction*=Math::PI
    @direction%=360


    if @particles.count >= @max_particles
      if @particles.delete(@particles.first)
      end
    end


    particle = Particle.new(@particle_image, self.x, self.y, 299, 255, @direction, @particle_speed, @particle_decay)
    @particles.push(particle)

    # puts "P: #{@particles.count}"
  end

  def destroy
    @particles.each {|p| @particles.delete(p)}
    super
  end
end
