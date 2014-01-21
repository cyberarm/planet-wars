class Target < Chingu::GameObject
  trait :bounding_circle
  trait :collision_detection
  def setup
    @image = TexPlay.create_image($window,10,10)
  end
end