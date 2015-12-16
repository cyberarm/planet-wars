class FriendlyAI < AI
  def setup
    state  = :seek # [:seek, :attack, :retreat]
  end

  def update
    @tick+=1

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

    if @tick >= 60
      @tick = 0
      game_object.fire_bullet!
    end

    @tick += 1
  end

  def retreat
    @planet = game_object.find_closest(Base) unless defined?(@portal) # Don't change destination

    if game_object.x.between?(@planet.x.to_f   - 12.0, @planet.x.to_f + 12.0)
      if game_object.y.between?(@planet.y.to_f - 12.0, @planet.y.to_f + 12.0)
        game_object.heal
      end
    end

    if @tick >= 60
      @tick = 0
      game_object.fire_bullet! if game_object.target_area.in_range
    end

    @tick += 1
    move(@portal)
  end
end
