class Player

	attr_accessor :x, :y, :score

	def initialize(window)
		@image = Gosu::Image.new(window, './gfx/player.png', false)
		@x = @y = 0.0
		@score = 0
	end

	def warp(x, y)
		@x, @y = x, y
	end

	def move_left
		if @x > 0
			@x -= 5
		else
			@x = 0
		end
	end

	def move_right
		if @x < 700
			@x += 5
		else
			@x = 700
		end
	end

	def draw
		@image.draw(@x, @y, 1)
	end
end