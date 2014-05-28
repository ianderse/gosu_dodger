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
	end

	def update
		if rand(100) < 4 and @enemies.size < 10
        	@enemies.push(Enemy.new(self))
        end

		@enemies.each { |enemy| enemy.move }
        @player.move_left if self.button_down?(Gosu::KbLeft)
        @player.move_right if self.button_down?(Gosu::KbRight)

        @enemies.each do |enemy|
        	if Gosu::distance(enemy.x, enemy.y, @player.x, @player.y) < 40
        		self.close
        	end
        end

        @enemies.reject! do |enemy|
        	if enemy.bottom?
        		@player.score += 5
        		true
        	else
        		false
        	end
        end
	end

	def draw
		@background.draw(0,0,0)
		@player.draw
		@enemies.each { |enemy| enemy.draw }

		@font.draw("Score: #{@player.score}", 10, 10, 1, 1.0, 1.0, 0xffffff00)
	end

	def button_up(key)
		self.close if key == Gosu::KbEscape
	end
end

window = GameWindow.new
window.show