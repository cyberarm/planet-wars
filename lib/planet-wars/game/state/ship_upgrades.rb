class ShipUpgrades < GameState
  def setup
    @ship = Ship.all.first

    @instructions = Text.new("(Enter|X) Back, (1|A) Upgrade Speed, (2|B) Upgrade Boost Speed, (3|Y) Upgrade Boost Capacity", x: 10, size: 25, z: 10_000)
    @costs = Text.new("Speed: 200 Gold, Boost Speed: 100 Gold, Boost Capacity: 100 Gold", x: 10, y: 40, size: 25, z: 10_000)
    @current = Text.new("Speed: #{@ship.speed}, Boost Speed: #{@ship.boost_speed}, Boost Capacity: #{@ship.max_boost}", x: 10, y: 80, size: 25, z: 10_000)
    @resources = Text.new("Your Gold: #{@ship.gold}", x: 10, size: 25, y: 120, z: 10_000)
    @tick = 0
  end

  def draw
    super
    @instructions.draw
    @costs.draw
    @current.draw
    @resources.draw
  end

  def update
    super
    @tick+=1
    @resources.text = "Your Gold: #{@ship.gold}"
    @current.text = "Speed: #{@ship.speed}, Boost Speed: #{@ship.boost_speed}, Boost Capacity: #{@ship.max_boost}"
  end

  def button_up(id)
    # self.input = {
    #   [:enter, :return, :gp_2] => :return_to_game,
    #   [:gp_0] => :upgrade_speed,
    #   [:gp_1] => :upgrade_boost_speed,
    #   [:gp_3] => :upgrade_boost_capacity
    # }
    @ship.upgrade_speed if id == (Gosu::Kb1)
    @ship.upgrade_boost_speed if id == (Gosu::Kb2)
    @ship.upgrade_boost_capacity if id == (Gosu::Kb3)
    return_to_game if id == (Gosu::KbEnter) || id == (Gosu::KbReturn) || id == (Gosu::KbEscape)
  end

  def return_to_game
    push_game_state(@options[:game]) if @tick >= 15
  end

  def upgrade_speed
    @ship.upgrade_speed
  end

  def upgrade_boost_speed
    @ship.upgrade_boost_speed
  end

  def upgrade_boost_capacity
    @ship.upgrade_boost_capacity
  end
end
