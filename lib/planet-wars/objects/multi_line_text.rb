class MultiLineText
  def initialize(text, options={})
    @texts = []
    text.split("\n").each_with_index do |line, i|
      _options = options
      _options[:y]+=_options[:size]
      @texts << Text.new(line, _options)
    end
  end

  def draw
    @texts.each(&:draw)
  end
end
