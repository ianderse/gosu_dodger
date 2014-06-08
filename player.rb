require './bullet'

class Player

	attr_accessor :x, :y, :score, :topscore

	def initialize(window)
		@image = Gosu::Image.new(window, './data/gfx/player.png', false)
		@window = window
		@x = @y = 0.0
		@score = 0
		@topscore = 0
	end

	def warp(x, y)
		@x, @y = x, y
	end

	def move_left
		if @x > 50
			@x -= 5
		else
			@x = 50
		end
	end

	def move_right
		if @x < 750
			@x += 5
		else
			@x = 750
		end
	end

	def draw
		@image.draw_rot(@x, @y, 1, 0)
	end

	def shoot
		Bullet.new(self, @window)
	end
end