class Explosion
	attr_reader :x, :y
		

	def initialize(enemy, window)
		@enemy = enemy
		@image = Gosu::Image.new(window, './data/gfx/laserGreenShot.png', false)

		@x = enemy.x
		@y = enemy.y
	end

	def draw
		@image.draw_rot(@x+5, @y+5, 2, 0)
	end
end