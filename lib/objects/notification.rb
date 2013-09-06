class Notification < Chingu::GameObject
  trait :effect
  trait :timer

  def initialize(options={})
    super
  end

  def setup
    @blink     = @options[:blink]
    @object    = @options[:object] || Ship.all.first
    @show      = true
    @color     = @options[:color] || Gosu::Color::WHITE
    @message   = Text.new(@options[:message], z: 999, size: 25, color: @color)
    @show_for  = @options[:show_for] || 3000
    @message.x = @object.x-@message.width/2
    @message.y = @object.y-100

    after(@show_for) do
      self.destroy
    end

    if @blink
      every(500) do
        toggle
      end
    end
  end

  def toggle
    if @show
      @show = false
    else
      @show = true
    end
  end

  def draw
    super
    @message.draw if @show
  end

  def update
    @message.text = "#{@options[:message]}"
    @message.x = @object.x-@message.width/2
    @message.y = @object.y-100
  end
end