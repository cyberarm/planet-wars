class GameResourcesHUD
  def initialize(ship)
    @ship = ship
    @resource_text = Text.new('Resources', x: $window.width-(30*10), y: 520, size: 32)
    @diamond_text  = Text.new('', x: $window.width-(30*10), y: 550, size: 18)
    @gold_text     = Text.new('', x: $window.width-(30*10), y: 570, size: 18)
    @oil_text      = Text.new('', x: $window.width-(30*10), y: 590, size: 18)
  end

  def draw
    @resource_text.draw
    @diamond_text.draw
    @gold_text.draw
    @oil_text.draw
  end

  def update
    @diamond_text.text = "Diamond: #{@ship.diamond.to_f.round(2)}"
    @gold_text.text    = "Gold: #{@ship.gold.to_f.round(2)}"
    @oil_text.text     = "Oil: #{@ship.oil.to_f.round(2)}"
  end
end
