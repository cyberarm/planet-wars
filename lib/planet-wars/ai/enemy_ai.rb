class EnemyAI < AI
  # TODO: Write AI.
  def setup
    game_object = self.game_object
    @machine = FiniteMachine.define do
      initial :seek
      target game_object

      events do
        event :seek, :seek => :attack
      end

      callbacks do
        on_enter(:seek) do |event|
          p event
          p target.inspect
       end
      end
    end

    puts @machine.current
  end
end
