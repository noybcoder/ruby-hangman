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
    guess = player.make_guess(@wrong_letters, @guess_display)
    answer = computer.secret_word

    guess_matched_indices = get_guess_matched_indices(guess, answer)

    if incorrect_guess?(guess_matched_indices)
      @remaining_chances -= 1
      store_wrong_letters(guess)
    else
      update_display(guess_matched_indices, guess)
    end
  end

  def win?(symbol='?')
    @guess_display.none?(symbol)
  end

  def lose?
    @remaining_chances.zero? && !win?
  end

  def get_guess_matched_indices(guess, answer)
    answer.chars.each_index.select { |idx| answer[idx] == guess }
  end

  def incorrect_guess?(guess_match_indices)
    guess_match_indices.empty?
  end

  def store_wrong_letters(guess)
    @wrong_letters << guess
  end

  def update_display(guess_match_indices, guess)
    guess_match_indices.each { |idx| @guess_display[idx] =  guess }
  end

end

game = Game.new

game.play
