class Rocket < GameObject
  # Tracking projectile
  # Targetable: Asteroid, Enemy.
  # TODO: Make me work, please!
  # TODO: Add laser to Ship to indictate what object the rocket will lock on too.

  def setup
    @owner  = options[:owner]
    @target = options[:target]
  end

  def draw
    # Render rocket
  end

  def update
    # Pursue target
  end
end
