class GameUpgradeHUD
  def initialize(ship)
    @ship = ship
    @instructions  = Text.new('Upgrades', x: $window.width-(30*10), y: 420, size: 32)
    @upgrade_speed_text  = Text.new('', x: $window.width-(30*10), y: 450, size: 11)
    @upgrade_boost_text  = Text.new('', x: $window.width-(30*10), y: 460, size: 11)
    @upgrade_boosc_text  = Text.new('', x: $window.width-(30*10), y: 470, size: 11)
  end

  def draw
    @instructions.draw
    @upgrade_speed_text.draw
    @upgrade_boost_text.draw
    @upgrade_boosc_text.draw
  end

  def update
    @upgrade_speed_text.text = "Speed: #{@ship.speed}/#{@ship.lock_speed}"
    @upgrade_boost_text.text = "Boost Speed: #{@ship.boost_speed}/#{@ship.lock_boost_speed}"
    @upgrade_boosc_text.text = "Boost Capacity: #{@ship.max_boost}/#{@ship.lock_max_boost}"
  end
end
