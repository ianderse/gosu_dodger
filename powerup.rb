class Powerup
	attr_accessor :x, :y

	def initialize(enemy, window)
		@enemy = enemy
		@image = Gosu::Image.new(window, './data/gfx/shield.png', false)
		@x = @enemy.x
		@y = @enemy.y
	end

	def move
		@y -= 5
	end

	def draw
		@image.draw_rot(@x, @y, 0, center_x = 0.5, center_y = 0.5)
	end
end