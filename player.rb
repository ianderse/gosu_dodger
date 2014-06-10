class Player

	attr_accessor :x, :y, :score, :topscore, :shield_count

	def initialize(window)
		@image = Gosu::Image.new(window, './data/gfx/player.png', false)
		@window = window
		@x = @y = 0.0
		@score = 0
		@topscore = 0
		@shield_count = 3
	end

	def power_up_shield
		@player.shield_count += 1
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