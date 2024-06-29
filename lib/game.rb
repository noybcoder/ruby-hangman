require_relative 'player'
require_relative 'computer'

class Game
  attr_accessor :player, :computer, :guess_display, :wrong_letters

  def initialize
    @player = Player.new
    @computer = Computer.new
    @guess_display = Array.new(computer.secret_word.length, '?')
    @wrong_letters = []
  end

  def verify_guess
    puts computer.secret_word
    computer.secret_word.include?(player.make_guess)
  end

end

game = Game.new
p game.verify_guess
