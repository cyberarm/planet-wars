class EnemyAI < AI
  def setup
    state  = :seek # [:seek, :attack, :retreat]
  end

  def update
    case state
    when :seek
      seek
    when :attack
      attack
    when :retreat
      retreat
    end
  end

  def seek
    if !defined?(@count) && !defined?(@planet)
      @count = Planet.all.count
      @planet= Planet.all[rand(0..@count)-1]

    elsif defined?(@count) && defined?(@planet)
      if game_object.x.between?(@planet.x-64, @planet.x+64)
        if game_object.y.between?(@planet.y-64, @planet.y+64)
          @planet= Planet.all[rand(0..@count)-1] # Change planet
        end
      end
    end

    move(@planet)
  end

  def attack
    move(game_object.target)

    if game_object.tick >= 60
      game_object.tick = 0
      game_object.fire_bullet!
    end

    game_object.tick += 1
  end

  def retreat
    portal = game_object.find_closest(Portal)

    portal.despawn(true)
    if game_object.x.between?(portal.x-12, portal.x+12)
      if game_object.y.between?(portal.y-12, portal.y+12)
        game_object.despawn(portal)
      end
    end

    if game_object.tick >= 60
      game_object.tick = 0
      game_object.fire_bullet! if game_object.target_area.in_range
    end

    game_object.tick += 1

    move(portal)
  end
end
