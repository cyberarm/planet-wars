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
    @upgrade_speed_text.text = "1. Speed: #{@ship.speed}"
    @upgrade_boost_text.text = "2. Boost Speed: #{@ship.boost_speed}"
    @upgrade_boosc_text.text = "3. Boost Capacity: #{@ship.max_boost}"
  end
end
