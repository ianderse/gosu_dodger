class Enemy
	attr_reader :x, :y
		

	def initialize(window)
		@image = Gosu::Image.new(window, './gfx/enemyship.png', false)

		@x = rand * 700
		@y = rand * 100

		@speed = 2 + (rand * 6)
	end

	def draw
		@image.draw_rot(@x, @y, 1, 0, center_x = 0.5, center_y = 0.5, factor_x = 0.5, factor_y = 0.5)
	end

	def move
		@y += @speed
	end

	def bottom?
		if y > 600
			true
		else
			false
		end
	end
end