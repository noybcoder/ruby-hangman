require_relative 'player'
require_relative 'computer'

class Game
  attr_accessor :player, :computer, :remaining_chances, :guess_display, :wrong_letters

  def initialize
    @player = Player.new
    @computer = Computer.new
    @remaining_chances = 10
    @guess_display = Array.new(computer.secret_word.length, '?')
    @wrong_letters = []
  end

  def play
    until win? || lose?
      puts @remaining_chances
      update_progress
      puts guess_display.join(' ')
      p @wrong_letters
      if win?
        puts 'You win!'
      elsif lose?
        puts 'You lose!'
      end
    end
  end

  def update_progress
    guess = player.make_guess
    answer = computer.secret_word

    current_display = answer.chars.map {|char| char == guess ? guess : '?'}
    if incorrect_guess?(current_display)
      @remaining_chances -= 1
      store_wrong_letters(guess)
    else
      update_display(current_display)
    end
  end

  def win?
    @guess_display.none?('?')
  end

  def lose?
    @remaining_chances.zero? && !win?
  end

  def incorrect_guess?(current_display, symbol='?')
    current_display.all?(symbol)
  end

  def store_wrong_letters(guess)
    @wrong_letters << guess
  end

  def update_display(current_display)
    @guess_display = current_display
  end

end

game = Game.new

game.play
