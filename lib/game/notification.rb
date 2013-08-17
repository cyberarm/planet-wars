class Notification < Chingu::GameObject
  trait :effect
  trait :timer

  def setup
    @message  = Text.new(@options[:message], z: 999, size: 25, color: Gosu::Color::YELLOW)
    @show_for = @options[:show_for] || 3000
    after(@show_for) do
      self.destroy
    end
  end

  def draw
    super
    @message.draw
  end

  def update
    @message.text = "#{@options[:message]}-#{@show_for}"
    @message.x    = Ship.all.first.x
    @message.y    = Ship.all.first.y-40
  end
end