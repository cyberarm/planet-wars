class Notification < Chingu::GameObject
  trait :effect

  def setup
    @message = Chingu::Text.new(@options[:message], x: Ship.all.first.x, y: Ship.all.first.y, zorder: 55, z: 55, color: Gosu::Color::WHITE)
    @show_for = @options[:show_for] || 300
  end

  def draw
    super
    if @show_for >= 1
      @message.draw
    else
      self.destroy
    end
  end

  def update
    @show_for -= 1
    @message.text = "#{@options[:message]}\n#{@show_for}"
  end
end