class Game < Chingu::GameState
  trait :timer
  trait :viewport

  def setup
    @music = Gosu::Sample["music/three.ogg"].play(0.5, 1, true) unless ARGV.first == '-d'

    WorldGen.new(40, 3000, 3000)
    @ship = Ship.create(x: 3000/2, y: 3000/2, zorder: 100, world: [0,3000,0,3000])#x-left, x-right, y-, y

    @fps = Chingu::Text.new('', x: 10, y: 10)
    @ship_location = Chingu::Text.new('', x: 10, y: 30)
    @ship_boost = Chingu::Text.new('', x: 10, y: 60)

    @planet_check = 0

    viewport.lag  = 0.22
    viewport.game_area = [0, 0, 1000*3, 1000*3]
  end

  def draw
    super
    @fps.draw
    @ship_location.draw
    @ship_boost.draw
  end

  def update
    super
    @fps.text = "FPS: #{$window.fps}"
    @ship_location.text = "X: #{@ship.x}\nY: #{@ship.y}"
    @ship_boost.text = "Boost: #{@ship.boost}"
    self.viewport.center_around(@ship)

    planet_check
    # collision_check
    key_check
  end

  def needs_cursor?
    true
  end

  def planet_check
    if @planet_check >= 3
      Planet.each_collision(Planet) do |one, two|
        two.destroy
        Planet.create(x: rand($window.width), y: rand($window.height), zorder: 0) unless $window.fps < 30
      end
    end

    @planet_check += 1
  end

  def key_check
    if $window.button_down?(Gosu::KbEscape)
      close
      exit
    end
  end
end