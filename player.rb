class Player

	attr_accessor :x, :y

	def initialize(window)
		@image = Gosu::Image.new(window, './gfx/player.png', false)
		@x = @y = @vel_x = @vel_y = @angle = 0.0
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

	def accelerate
		@vel_x += Gosu::offset_x(@angle, 0.5)
		@vel_y += Gosu::offset_y(@angle, 0.5)
	end

	def move
		@x += @vel_x
		@y += @vel_y
		@x %= 800
		@y %= 600

		@vel_x *= 0.95
		@vel_y *= 0.95
	end

	def draw
		@image.draw_rot(@x, @y, 1, @angle)
	end
end