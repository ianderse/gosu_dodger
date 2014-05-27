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
end