class MiniMapGenerator
  attr_reader :image
  def initialize(area, objects, ship)
    #area = [play area width, play area height]
    #objects = [Planets, Stars]
    @area    = area
    @objects = objects
    @ship    = ship
    @image   = TexPlay.create_image($window, area[0]/100, area[1]/100)
    generate_image
    # @image.save("#{Dir.pwd}/lib/dev_stats/minimap.png")
    return @image
  end

  def generate_image
    @objects.each do |object|
      if object.habitable
        @image.pixel(object.x/100, object.y/100, color: :blue)
      else
        @image.pixel(object.x/100, object.y/100, color: :yellow)
      end
    end

    @image.pixel(@ship.x/100, @ship.y/100, color: :green)
  end
end

# class MiniMapGenerator
#   def initialize(area, objects, ship)
#     #area = [play area width, play area height]
#     #objects = [Planets, Stars]
#     @area    = area
#     @objects = objects
#     @ship    = ship
#     @image   = ChunkyPNG::Image.new(area[0]/100, area[1]/100, ChunkyPNG::Color::TRANSPARENT)
#     generate_image
#     # @image.save("#{Dir.pwd}/lib/dev_stats/minimap.png")
#     return @image.to_s
#   end
# 
#   def generate_image
#     @objects.each do |object|
#       if object.habitable
#         @image[object.x/100.to_i,object.y/100.to_i] = ChunkyPNG::Color('blue @ 1.0')
#       else
#         @image[object.x/100.to_i,object.y/100.to_i] = ChunkyPNG::Color('yellow @ 1.0')
#       end
#     end
# 
#     @image[@ship.x/100.to_i,@ship.y/100.to_i] = ChunkyPNG::Color('green @ 1.0')
#   end
# 
#   def size
#     @area[0]/100 * @area[1]/100 * 4
#   end
# end