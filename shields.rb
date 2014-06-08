class Shields

	attr_accessor :x, :y, :status, :counter

	def initialize(player, window)
		@player = player
		@image = Gosu::Image.new(window, './data/gfx/shield.png', false)
		@x = @player.x
		@y = @player.y
		@counter = 0
		@status = false
	end

	def draw
		@image.draw_rot(@x, @y-5, 1, 1)
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

	def toggle
		@counter = 0
		if @player.shield_count > 0
			@player.shield_count -= 1
			@status = true
		else
			@status = false
		end
	end
end