class GameHUD
  attr_reader :time, :clock_time

  def initialize
    GameHUD.instance=self

    @current_wave = GameInfo::Mode.current_wave
    @time         = 0
    @clock_time   = 0#GameInfo::Config.game_time
    @clock_counter= 0
    @clock_text   = Text.new('', x: $window.width/2, size: 20)
    @game_message = Text.new('', y: $window.height/2-150, size: 70)
    @message_tick = 0
    @minimap      = MiniMap.new
    @boost_bar    = BoostBar.new
    @health_bar   = HealthBar.new
    @notifications= NotificationManager.new
  end

  def self.instance
    @instance
  end
  def self.instance=(_instance)
    @instance = _instance
  end

  def draw
    @clock_text.draw
    @boost_bar.draw
    @health_bar.draw
    @minimap.draw
    @notifications.draw
    @game_message.draw
  end

  def update
    @clock_counter+=1
    if @clock_counter <= 60
      @clock_time+=0.01667
      @clock_counter=0
    end
    @time = Time.at((@clock_time)).gmtime
    # GameInfo::Config.game_time=time # Fix later
    GameInfo::Config.game_time_processed=@time # remove me later
    @clock_text.text = "#{@time.strftime('%T')}"
    @minimap.update
    @health_bar.update
    @boost_bar.update
    @notifications.update
    game_message_update
  end

  def game_message_update
    @message_tick+=1
    if @message_tick >= 60*2
      @game_message.text=""
      if @message_tick >= 12
        if GameInfo::Mode.current_wave > @current_wave
          @message_tick = 0
          game_message_show
          @current_wave = GameInfo::Mode.current_wave
        end
      end
    else
      game_message_show
    end
  end

  def game_message_show
    case GameInfo::Mode.mode
    when "survival"
      @game_message.text = "Get Ready!"
      @game_message.x = $window.width/2-@game_message.width/2
    when "wave"
      @game_message.text = "Wave #{GameInfo::Mode.current_wave.humanize}"
      @game_message.x = $window.width/2-@game_message.width/2
    end
  end
end
