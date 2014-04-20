class GameHUD
  def initialize
    @clock_time = 0#GameInfo::Config.game_time
    @clock_counter=0
    @clock_text   = Text.new('', x: $window.width/2, size: 20)
    @minimap      = MiniMap.new
    @boost_bar    = BoostBar.new
    @health_bar   = HealthBar.new
    @notifications= NotificationManager.new
  end

  def draw
    @clock_text.draw
    @boost_bar.draw
    @health_bar.draw
    @minimap.draw
    @notifications.draw
  end

  def update
    @clock_counter+=1
    if @clock_counter <= 60
      @clock_time+=0.017
      @clock_counter=0
    end
    time = Time.at((@clock_time)).gmtime.strftime('%R:%S')
    GameInfo::Config.game_time_processed=time
    @clock_text.text = "#{time}"
    @minimap.update
    @health_bar.update
    @boost_bar.update
    @notifications.update
  end
end