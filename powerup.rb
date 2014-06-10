class Powerup
	attr_accessor :x, :y

	def initialize(enemy, window, type)
		@enemy = enemy
		@type = type

		if @type == 1 #shield dropped
			@image = Gosu::Image.new(window, './data/gfx/sicon.png', false)
		end

		@x = @enemy.x
		@y = @enemy.y
	end

	def bottom?
		if y > 600
			true
		else
			false
		end
	end

	def move
		@y += 3
	end

	def draw
		@image.draw_rot(@x, @y, 0, center_x = 0.5, center_y = 0.5)
	end
end