class MultiLineText
  attr_accessor :x, :y, :width, :height

  def initialize(text, options={})
    @texts = []
    text.split("\n").each_with_index do |line, i|
      _options = options
      _options[:y]+=_options[:size]
      @texts << Text.new(line, _options)
    end
    @x = @texts.first.x
    @y = @texts.first.y
    @height = 0
    @texts.each {|t| @height+=t.height}
  end

  def y=(int)
    @y = int
    @texts.each_with_index {|t, i| puts ("y:#{y} int:#{int} m:#{int+(i*t.size)}");t.y=int+(i*t.size)}
  end

  def draw
    @texts.each(&:draw)
  end
end
