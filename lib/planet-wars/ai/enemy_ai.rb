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
      if game_object.x.between?(@planet.x-64.0, @planet.x+64.0)
        if game_object.y.between?(@planet.y-64.0, @planet.y+64.0)
          @planet= Planet.all[rand(0..@count)-1] # Change planet
        end
      end
    end

    move(@planet)
  end

  def attack
    move(game_object.target)

    if (Engine.now-@last_fired_at) >= 1000.0
      @last_fired_at = Engine.now
      game_object.fire_bullet! if game_object.target_area.in_range
    end
  end

  def retreat
    @portal = game_object.find_closest(Portal) unless defined?(@portal) # Don't change destination

    @portal.despawn(true)
    begin
      if game_object.x.between?(@portal.x-12.0, @portal.x+12.0)
        if game_object.y.between?(@portal.y-12.0, @portal.y+12.0)
          game_object.despawn(@portal)
        end
      end
    rescue ArgumentError => e
      Logger.log("#{e} - #{game_object.x}|#{game_object.y}", self)
    end

    if (Engine.now-@last_fired_at) >= 1000.0
      @last_fired_at = Engine.now
      game_object.fire_bullet! if game_object.target_area.in_range
    end

    move(@portal)
  end
end
