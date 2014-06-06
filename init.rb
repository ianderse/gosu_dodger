require 'gosu'
require './player'
require './enemy'
require 'rubygems'

class GameWindow < Gosu::Window
	def initialize
		super 800, 600, false
		self.caption = "Gosu Tutorial"

		@font = Gosu::Font.new(self, Gosu::default_font_name, 20)

		@background = Gosu::Image.new(self, './gfx/blue_stars_800x600.png')

		@player = Player.new(self)
		@player.warp(350, 520)

		@enemies = Array.new

		@game_is_paused = false
	end

	def update
		if @game_is_paused == false

			#add new enemy to enemy array
			if rand(100) < 4 and @enemies.size < 10
	        	@enemies.push(Enemy.new(self))
	        end

	        #move enemy
			@enemies.each { |enemy| enemy.move }

			#move player
	        @player.move_left if self.button_down?(Gosu::KbLeft)
	        @player.move_right if self.button_down?(Gosu::KbRight)

	        #Collision detection

	        @enemies.each do |enemy|
	        	if Gosu::distance(enemy.x, enemy.y, @player.x, @player.y) < 40
	        		self.close
	        	end
	        end

	        #remove enemy from array (and screen) when it hits the bottom of the screen, add to player score
	        @enemies.reject! do |enemy|
	        	if enemy.bottom?
	        		@player.score += 5
	        		true
	        	else
	        		false
	        	end
	        end
		end
	end

	def draw
		@background.draw(0,0,0)
		@player.draw
		@enemies.each { |enemy| enemy.draw }

		@font.draw("Score: #{@player.score}", 10, 10, 1, 1.0, 1.0, 0xffffff00)
	end

	def game_pause_toggle
		@game_is_paused = !@game_is_paused
	end

	def button_up(key)
		self.close if key == Gosu::KbEscape
		game_pause_toggle if key == Gosu::KbSpace
	end
end

window = GameWindow.new
window.show