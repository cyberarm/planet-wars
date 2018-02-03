class ParticleEmitter < GameObject
  attr_accessor :emit, :particle_image, :angle
  attr_accessor :image, :x, :y, :z, :alpha, :direction, :speed, :wobble, :decay

  class Particle
    attr_accessor :image, :x, :y, :z, :alpha, :direction, :speed, :decay, :wobble, :last_x, :last_y
    def initialize(options={})
      @image = options[:image] ? options[:image] : nil
      @x = options[:x] ? options[:x] : 0
      @y = options[:y] ? options[:y] : 0
      @z = options[:z] ? options[:z] : 0
      @alpha = options[:alpha] ? options[:alpha] : 255
      @direction = options[:direction] ? options[:direction] : 0
      @angle = options[:angle] ? options[:angle] : nil
      @wobble = options[:wobble] ? options[:wobble] : 2.5
      @speed = options[:speed] ? options[:speed] : 1
      @decay = options[:decay] ? options[:decay] : 1

      @debug_color = Gosu::Color::FUCHSIA

      @last_x,@last_y = @x, @y
    end

    def draw
      @image.draw(@x, @y, @z, 1, 1, Gosu::Color.rgba(255,255,255, @alpha))

      if $debug
        direction = ((Gosu.angle(@last_x, @last_y, self.x, self.y)) - 90.0) * (Math::PI / 180.0)
        _x = @x+(50*Math.cos(direction))
        _y = @y+(50*Math.sin(direction))
        $window.draw_line(@x+@image.width/2, @y+@image.height/2, @debug_color, _x, _y, @debug_color, 9999)
      end
    end

    def animate(particle)
      particle.alpha-=particle.decay
      particle.last_x = particle.x
      particle.last_y = particle.y
      if @direction == 0
        it = particle.direction * (Math::PI / 180.0)
        particle.x+=((particle.speed*60)*Engine.dt)*Math.cos(it)
        particle.y+=((particle.speed*60)*Engine.dt)*Math.sin(it)
      else
        particle.x-=((particle.speed*60)*Engine.dt)*Math.cos(particle.direction)
        particle.y-=((particle.speed*60)*Engine.dt)*Math.sin(particle.direction)
      end
    end
  end

  # ParticleEmitter
  def setup
    @image = options[:image] ? options[:image] : nil
    @x = options[:x] ? options[:x] : 0
    @y = options[:y] ? options[:y] : 0
    @z = options[:z] ? options[:z] : 0
    @alpha = options[:alpha] ? options[:alpha] : 255
    @direction = options[:direction] ? options[:direction] : 0
    @angle = options[:angle] ? options[:angle] : nil
    @speed = options[:speed] ? options[:speed] : 2
    @decay = options[:decay] ? options[:decay] : 2.5
    @wobble = options[:wobble] ? options[:wobble] : 2.5
    @max_particles = options[:max_particles] ? options[:max_particles] : 100
    @particles_per_second = options[:particles_per_second] ? options[:particles_per_second] : 200

    @particle_direction = @direction

    @particles = []
    @time = 0.0
    @emit = true

    @particle_image = AssetManager.get_image(AssetManager.particles_path+"/particle.png")
  end

  def draw
    @particles.each(&:draw)
  end

  def update
    # puts @particles.countv
    @particles.each do |p|
      p.animate(p)
      @particles.delete(p) if p.alpha <= 0
    end

    if @emit && @particles.count < @max_particles
      p "Particles This Frame: #{(Engine.dt*@particles_per_second)}->#{(Engine.dt*@particles_per_second).to_i}"
      (Engine.dt*@particles_per_second).to_i.times do
        create_particle
      end
    end
  end

  def x=(i)
    @last_x = self.x
    @x = i
  end
  def y=(i)
    @last_y = self.y
    @y = i
  end

  def create_particle
    if @direction && !@angle
      @particle_direction+=15*Math::PI
      @particle_direction%=360
    else
      _direction = (self.angle - 90.0) * (Math::PI / 180.0)
      @particle_direction = _direction
      # @particle_direction%=360
    end

    if @particles.count >= @max_particles
      if @particles.delete(@particles.first)
      end
    end


    particle = Particle.new(image: @particle_image, x: self.x, y: self.y, z: 299, alpha: 255, wobble: @wobble, direction: @particle_direction, speed: @speed, decay: @decay)
    @particles.push(particle)
  end

  def destroy
    @particles.each {|p| @particles.delete(p)}
    super
  end
end
