require "chingu"
class Sampler < Chingu::Window
  def initialize
    super(120,120,false)
    @sound = Gosu::Sample["./error.ogg"].play
    @tick = 0
  end

  def update
    @tick+=1
    close unless @sound.playing? && @tick <= 300
  end
end

Sampler.new.show
