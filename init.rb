require 'gosu'
require './player'
require 'rubygems'

class GameWindow < Gosu::Window
	def initialize
		super 800, 600, false
		self.caption = "Gosu Tutorial"

		@font = Gosu::Font.new(self, Gosu::default_font_name, 20)

		@background = Gosu::Image.new(self, './gfx/blue_stars_800x600.png')

		@player = Player.new(self)
		@player.warp(450, 550)
	end

	def update
        @player.move_left if self.button_down?(Gosu::KbLeft)
        @player.move_right if self.button_down?(Gosu::KbRight)
        #@player.accelerate if self.button_down?(Gosu::KbUp)

        @player.move
	end

	def draw
		@background.draw(0,0,0)
		@player.draw

		@font.draw("X: #{@player.x}", 10, 10, 1, 1.0, 1.0, 0xffffff00)
	end

	def button_up(key)
		self.close if key == Gosu::KbEscape
	end
end

window = GameWindow.new
window.show