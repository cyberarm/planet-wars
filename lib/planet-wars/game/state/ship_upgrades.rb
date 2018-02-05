class ShipUpgrades < GameUI
  def create
    set_title("")
    @ship = Ship.all.first
    if Base.all.count > 0
      button "Upgrade Speed", tooltip: "200 Gold" do
        upgrade_speed
      end
      button "Upgrade Boost Speed", tooltip: "100 Gold" do
        upgrade_boost_speed
      end
      button "Upgrade Boost Capacity", tooltip: "100 Gold" do
        upgrade_boost_capacity
      end
    end
    button "Back" do
      $window.show_cursor = false
      push_game_state(@options[:game])
    end

    @name   = Text.new("Ship upgrades", x: 10, y: 10, size: 30, z: 10_000)
    @current = Text.new("")
  end

  def draw
    super
    fill_rect(10, 40, $window.width-20, 4, Gosu::Color::WHITE, Float::INFINITY)
    @name.draw
    @current.draw
  end

  def update
    super
    if Base.all.count > 0
      @current = MultiLineText.new("Your Gold: #{@ship.gold.round(2)}\n\nCurrent Upgrades\nShip Speed: #{@ship.speed}/5\nBoost Speed: #{@ship.boost_speed}/3\nBoost Capacity: #{@ship.max_boost}/400", x: 100, y: 270+50, size: 25, z: 10_000)
    else
      @current = MultiLineText.new("Your Gold: #{@ship.gold.round(2)}\n\nCurrent Upgrades\nShip Speed: #{@ship.speed}\nBoost Speed: #{@ship.boost_speed}\nBoost Capacity: #{@ship.max_boost}\n\nBuild bases on planets\nto enable upgrades", x: 100, y: 270+50, size: 25, z: 10_000)
    end
  end

  # def button_up(id)
  #   super
  #   # self.input = {
  #   #   [:enter, :return, :gp_2] => :return_to_game,
  #   #   [:gp_0] => :upgrade_speed,
  #   #   [:gp_1] => :upgrade_boost_speed,
  #   #   [:gp_3] => :upgrade_boost_capacity
  #   # }
  #   @ship.upgrade_speed if id == (Gosu::Kb1)
  #   @ship.upgrade_boost_speed if id == (Gosu::Kb2)
  #   @ship.upgrade_boost_capacity if id == (Gosu::Kb3)
  #   return_to_game if id == (Gosu::KbEnter) || id == (Gosu::KbReturn) || id == (Gosu::KbEscape)
  # end
  def go_back
    return_to_game
  end

  def return_to_game
    $window.show_cursor = false
    push_game_state(@options[:game])
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
