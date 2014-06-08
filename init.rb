#TODO: 
#Add shields (3 per game, icons at the bottom)
#Ability to shoot (done)
#remove explosion gfx after a set amount of time (done)
#Parallax scrolling for background
#Powerups
#Extra point drops from enemies

require 'gosu'
require './player'
require './enemy'
require './explosion'
require 'rubygems'

class GameWindow < Gosu::Window
	def initialize width=800, height=600, fullscreen=false
		super
		self.caption = "Gosu Tutorial"

		@font = Gosu::Font.new(self, Gosu::default_font_name, 20)

		@background = Gosu::Image.new(self, './gfx/space.png', false)

		@player = Player.new(self)
		@player.warp(350, 520)

		@enemies = Array.new

		@bullets = Array.new

		@explodes = Array.new

		@game_is_paused = @game_over = false

		@frame = 0

	end

	def reset_game
		
		if @player.score > @player.topscore
			@player.topscore = @player.score
		end

		@player.score = 0

		@enemies.reject! do |enemy|
			true
		end

		@bullets.reject! do |bullet|
			true
		end

		game_pause_toggle
	end

	def update
		if @game_is_paused == false

			@frame += 1

			#add new enemy to enemy array
			if rand(100) < 4 and @enemies.size < 10
	        	@enemies.push(Enemy.new(self))
	        end

	        #move enemy
			@enemies.each { |enemy| enemy.move }

			#move bullets
			@bullets.each { |bullet| bullet.move }

			#move player
	        @player.move_left if self.button_down?(Gosu::KbLeft)
	        @player.move_right if self.button_down?(Gosu::KbRight)

	        @camera_x = [[@player.x - 400, 0].max, @player.y * 50 - 800].min
    		@camera_y = [[@player.y - 300, 0].max, @player.x * 50 - 600].min

	        #Collision detection
	        @enemies.each do |enemy|
	        	if Gosu::distance(enemy.x, enemy.y, @player.x, @player.y) < 40
	        		@game_over = true
	        		reset_game
	        	end
	        	@bullets.reject! do |bullet|
	        		@enemies.reject! do |enemy|
	        			if Gosu::distance(enemy.x, enemy.y, bullet.x, bullet.y) < 40
	        				@explodes.push(Explosion.new(enemy, self))
	        				@player.score += 5
	        				true
	        			end
	        		end
	        	end
	        end

	        #remove enemy from array (and screen) when it hits the bottom subtract from player score
	        @enemies.reject! do |enemy|
	        	if enemy.bottom?
	        		@player.score -= 2
	        		true
	        	else
	        		false
	        	end
	        end

	        #remove explosion based on time
	        if @explodes != nil
	        	if @frame > 35
	        		@explodes.shift
	        		@frame = 0
	        	end
	        end

	        #remove explosion based on number on scren
	        if @explodes.size > 5
	        	@explodes.shift
	        end
		end
	end

	def draw
		@background.draw(0,0,0)
		@player.draw
		@enemies.each { |enemy| enemy.draw }
		@bullets.each { |bullet| bullet.draw }
		@explodes.each { |exp| exp.draw }

		@font.draw("Score: #{@player.score}", 10, 10, 1, 1.0, 1.0, 0xffffff00)
		@font.draw("Top Score: #{@player.topscore}", 10, 30, 1, 1.0, 1.0, 0xffffff00)

		if @game_is_paused
			if @game_over
				@font.draw("GAME OVER", 265, 280, 1, 2.0, 2.0, 0xffffff00)
			else
				@font.draw("GAME IS PAUSED", 265, 280, 1, 2.0, 2.0, 0xffffff00)
			end
			@font.draw("press 'p' to resume", 255, 330, 1, 2.0, 2.0, 0xffffff00)
		end

	end

	def game_pause_toggle
		
		@game_is_paused = !@game_is_paused
	end

	def button_up(key)
		self.close if key == Gosu::KbEscape
		game_pause_toggle if key == Gosu::KbP
		@bullets.push(Bullet.new(@player, self)) if key == Gosu::KbLeftShift
	end
end

window = GameWindow.new
window.show