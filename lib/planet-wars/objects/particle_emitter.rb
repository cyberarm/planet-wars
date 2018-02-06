class ParticleEmitter < GameObject
  attr_accessor :emit, :particle_image, :angle
  attr_accessor :image, :x, :y, :z, :alpha, :direction, :speed, :spread, :decay

  class Particle
    attr_accessor :image, :x, :y, :z, :alpha, :direction, :speed, :decay, :spread, :last_x, :last_y
    def initialize(options={})
      @debug_color = Gosu::Color.rgb(255, 165, 0)

      @image = options[:image] ? options[:image] : nil
      @x = options[:x] ? options[:x] : 0
      @y = options[:y] ? options[:y] : 0
      @z = options[:z] ? options[:z] : 0
      @alpha = options[:alpha] ? options[:alpha] : 255
      @direction = options[:direction] ? options[:direction] : 0
      @angle = options[:angle] ? options[:angle] : nil
      @spread = options[:spread] ? options[:spread] : 2.5
      @speed = options[:speed] ? options[:speed] : 1
      @decay = options[:decay] ? options[:decay] : 1

      @spread_offset = 0
      @last_x,@last_y = @x, @y
      @velocity_x = 0
      @velocity_y = 0

      if @direction == 0
        it = self.direction * (Math::PI / 180.0)
        @velocity_x = ((self.speed*60)*Engine.dt)*Math.cos(it)
        @velocity_y = ((self.speed*60)*Engine.dt)*Math.sin(it)
      else
        @velocity_x = (((self.speed*60)*Engine.dt)*Math.cos(self.direction))
        @velocity_y = (((self.speed*60)*Engine.dt)*Math.sin(self.direction))
      end
    end

    def draw
      @image.draw(@x, @y, @z, 1, 1, Gosu::Color.rgba(255,255,255, @alpha))

      if $debug && $heading
        direction = ((Gosu.angle(@last_x, @last_y, self.x, self.y)) - 90.0) * (Math::PI / 180.0)
        _x = @x+(50*Math.cos(direction))
        _y = @y+(50*Math.sin(direction))
        $window.draw_line(@x+@image.width/2, @y+@image.height/2, @debug_color, _x, _y, @debug_color, 9999)
      end
    end

    def update
      self.alpha-=((self.decay*60)*Engine.dt)
      self.last_x = self.x
      self.last_y = self.y

      self.x-=@velocity_x
      self.y-=@velocity_y
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
    @spread = options[:spread] ? options[:spread] : 2.5
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
    @particles.each do |particle|
      particle.update
      @particles.delete(particle) if particle.alpha <= 0
    end

    if @emit && @particles.count < @max_particles
      # p "Particles This Frame: #{(Engine.dt*@particles_per_second)}->#{(Engine.dt*@particles_per_second).ceil}"
      (Engine.dt*@particles_per_second).ceil.times do
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
      if @angle
        @spread_offset = rand(-@spread..@spread)
      end
      _direction = (self.angle+@spread_offset - 90.0) * (Math::PI / 180.0)
      @particle_direction = _direction
      # @particle_direction%=360
    end

    if @particles.count >= @max_particles
      if @particles.delete(@particles.first)
      end
    end


    particle = Particle.new(image: @particle_image, x: self.x, y: self.y, z: 299, alpha: 255, spread: @spread, angle: @angle, direction: @particle_direction, speed: @speed, decay: @decay)
    @particles.push(particle)
  end

  def destroy
    @particles.each {|p| @particles.delete(p)}
    super
  end
end
