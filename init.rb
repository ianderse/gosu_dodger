#TODO: 
#Add shields (3 per game, icons at the bottom) (done)
#Ability to shoot (done)
#remove explosion gfx after a set amount of time (done)
#scrolling for background
#Powerups
#Extra point drops from enemies

require 'gosu'
require './player'
require './enemy'
require './explosion'
require './bullet'
require './shields'
require 'rubygems'

class GameWindow < Gosu::Window
	def initialize width=800, height=600, fullscreen=false
		super
		self.caption = "Gosu Tutorial"

		@song = Gosu::Song.new(self, './data/sound/space.mp3')
		@song.play

		@explode_sound = Gosu::Sample.new(self, './data/sound/explosion.wav')
		@player_shot_sound = Gosu::Sample.new(self, './data/sound/player_shot.wav')

		@shields_icon = Gosu::Image.new(self, './data/gfx/shield.png')

		@font = Gosu::Font.new(self, Gosu::default_font_name, 20)

		@background = Gosu::Image.new(self, './data/gfx/space.png', false)

		@player = Player.new(self)
		@player.warp(350, 520)

		@shield = Shields.new(@player, self)

		@enemies = Array.new

		@bullets = Array.new

		@explodes = Array.new

		@powerups = Array.new

		@game_is_paused = true
		@game_over = false

		@frame = 0

	end

	def reset_game

		if @player.score > @player.topscore
			@player.topscore = @player.score
		end

		@player.shield_count = 3

		@player.score = 0

		@shield.status = false

		@enemies.reject! do |enemy|
			true
		end

		@bullets.reject! do |bullet|
			true
		end

		@powerups.reject! do |powerup|
			true
		end

		game_pause_toggle
	end

	def update
		if @game_is_paused == false

			@frame += 1

			if @shield.status == true
				@shield.counter += 1
			end

			#add new enemy to enemy array
			if @player.score > 125
				if rand(100) < 15 and @enemies.size < 20
	        		@enemies.push(Enemy.new(self))
	        	end
			elsif @player.score > 75 && @player.score < 125
	        	if rand(100) < 8 and @enemies.size < 15
	        		@enemies.push(Enemy.new(self))
	        	end
			elsif @player.score < 75
				if rand(100) < 4 and @enemies.size < 10
	        		@enemies.push(Enemy.new(self))
	        	end
	        
	        end

	        #move enemy
			@enemies.each { |enemy| enemy.move }

			#move bullets
			@bullets.each { |bullet| bullet.move }

			#move powerups
			@powerups.each { |powerup| powerup.move }

			#move player
	        @player.move_left if self.button_down?(Gosu::KbLeft)
	        @player.move_right if self.button_down?(Gosu::KbRight)
	        @shield.move_left if self.button_down?(Gosu::KbLeft)
	        @shield.move_right if self.button_down?(Gosu::KbRight)

	        #Collision detection
	        @enemies.each do |enemy|
	        	if Gosu::distance(enemy.x, enemy.y, @player.x, @player.y) < 40
	        		if @shield.status == true
	        			@enemies.delete(enemy)
	        			@explode_sound.play
	        			@player.score += 5
	        		else
	        			@game_over = true
	        			reset_game
	        		end
	        	end
	        	@bullets.reject! do |bullet|
	        		@enemies.reject! do |enemy|
	        			if Gosu::distance(enemy.x, enemy.y, bullet.x, bullet.y) < 40
	        				@explode_sound.play
	        				@explodes.push(Explosion.new(enemy, self))
	        				@player.score += 5
	        				enemy.drop_powerup(@powerups, enemy, self)
	        				true
	        			end
	        		end
	        	end
	        end

	        @powerups.each do |powerup|
	        	if Gosu::distance(powerup.x, powerup.y, @player.x, @player.y) < 30
	        		if @player.shield_count < 3
	        			@player.shield_count += 1
	        		end
	        		@powerups.delete(powerup)
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

	        @powerups.reject! do |powerup|
	        	if powerup.bottom?
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
		@powerups.each { |powerup| powerup.draw }

		@font.draw("Score: #{@player.score}", 10, 10, 1, 1.0, 1.0, 0xffffff00)
		@font.draw("Top Score: #{@player.topscore}", 10, 30, 1, 1.0, 1.0, 0xffffff00)

		if @game_is_paused
			if @game_over
				@font.draw("GAME OVER", 265, 280, 1, 2.0, 2.0, 0xffffff00)
			else
				@font.draw("GAME IS PAUSED", 265, 280, 1, 2.0, 2.0, 0xffffff00)
				@font.draw("shift to shoot", 265, 380, 1, 2.0, 2.0, 0xffffff00)
			end
			@font.draw("press 'p' to resume", 255, 330, 1, 2.0, 2.0, 0xffffff00)
		end

		if @shield.status == true
			if @shield.counter > 125
				@shield.status = false
			end
			@shield.draw
		end

		@i = @player.shield_count
		while @i > 0
			@shields_icon.draw_rot(0+(@i*50), 575, 1, 0, center_x = 0.5, center_y = 0.5, factor_x = 0.25, factor_y = 0.25)
			@i -= 1
		end

	end

	def game_pause_toggle
		@game_is_paused = !@game_is_paused
	end

	def button_up(key)
		self.close if key == Gosu::KbEscape

		if key == Gosu::KbP
			@game_over = false
			game_pause_toggle 
		end

		if @game_is_paused == false
			if key == Gosu::KbLeftShift
				@player_shot_sound.play
				@bullets.push(Bullet.new(@player, self, 0)) 
			end
			if key == Gosu::KbSpace
				if @shield.status == false
					@shield.toggle
				end
			end
		end
	end
end

window = GameWindow.new
window.show