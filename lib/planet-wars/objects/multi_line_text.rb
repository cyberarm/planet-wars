class MultiLineText
  attr_accessor :options, :x, :y, :width, :height

  def initialize(text, options={})
    @texts = []
    text.split("\n").each_with_index do |line, i|
      _options = options
      _options[:y]+=_options[:size]
      @texts << Text.new(line, _options)
    end
    @options = options
    @x = @texts.first ? @texts.first.x : 0
    @y = @texts.first ? @texts.first.y : 0
    @width  = 0
    @height = 0
    calculate_boundry
  end

  def draw
    @texts.each(&:draw)
  end

  def text
    string = ""
    @texts.each {|t| string << t.text}
    return string
  end

  def text=(text)
    text.split("\n").each_with_index do |line, i|
      if @texts[i]
        @texts[i].text = line
      else
        @texts << Text.new(line, @options)
      end
    end

    calculate_boundry
  end

  def x=(int)
    @x = int
    @texts.each {|t| t.x = int}
  end

  def y=(int)
    @y = int
    @texts.each_with_index {|t, i| t.y=int+(i*t.size)}
  end

  def calculate_boundry
    @width = 0
    @height= 0
    @texts.each {|t| @width = t.width if t.width > @width}
    @texts.each {|t| @height+=t.height}
  end
end
