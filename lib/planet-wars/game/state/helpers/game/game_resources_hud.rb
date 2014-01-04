class GameResourcesHUD
  def initialize(ship)
    @ship = ship
    @resource_text = Text.new('Resources', x: $window.width-(30*10), y: 480, size: 40)
    @diamond_text  = Text.new('', x: $window.width-(30*10), y: 530, size: 11)
    @gold_text     = Text.new('', x: $window.width-(30*10), y: 540, size: 11)
    @oil_text      = Text.new('', x: $window.width-(30*10), y: 550, size: 11)
  end

  def draw
    @resource_text.draw
    @diamond_text.draw
    @gold_text.draw
    @oil_text.draw
  end

  def update
    @diamond_text.text = "Diamond: #{@ship.diamond}"
    @gold_text.text    = "Gold: #{@ship.gold}"
    @oil_text.text     = "Oil: #{@ship.oil}"
  end
end