class Bullet

	attr_accessor :x, :y

	def initialize(player, window)
		@player = player
		@image = Gosu::Image.new(window, './data/gfx/laserGreen.png', false)
		@x = @player.x
		@y = @player.y
	end

	def move
		@y -= 7
	end

	def draw
		@image.draw_rot(@x, @y, 1, 0)
	end
end