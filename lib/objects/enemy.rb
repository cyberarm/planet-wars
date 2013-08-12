class Enemy < Chingu::GameObject
  trait :effect
  def setup
    @image = Gosu::Image["./ships/enemy.png"]
  end

  def update
    rotate(1)
  end
end