require_relative 'player'
require_relative 'computer'
require_relative 'visualizable'
require 'json'

class Game
  include Visualizable
  attr_accessor :player, :computer, :tries, :guess_display, :wrong_letters

  def initialize
    @player = Player.new
    @computer = Computer.new
    @tries = 10
    @guess_display = Array.new(computer.secret_word.length, '_')
    @wrong_letters = []
  end

  def play
    load_progress
    until win? || lose?
      puts "\nRemaining Chances: #{@tries}"
      update_progress
      display_guess(@guess_display)
      display_hangman(@tries)
      display_wrong_letters(@wrong_letters)
      save_progress
      if win?
        puts 'You win!'
      elsif lose?
        puts 'You lose!'
      end
    end
  end

  def load_progress(file_name='save.txt')
    from_json(file_name) if player.load_game == 'y'
  end

  def from_json(file_name)
    save = read_save(file_name)
    @player = Player.deserialize(save['player'])
    @computer = Computer.deserialize(save['computer'])
    @tries = save['tries']
    @guess_display = save['guess_display']
    @wrong_letters = save['wrong_letters']
  end

  def read_save(file_name)
    save = File.read(file_name)
    JSON.load(save)
  end

  def save_progress(file_name='save.txt')
    save = to_json if player.save_game == 'y'
    write_save(save, file_name)
  end

  def to_json
    JSON.dump({
      :player => @player.serialize,
      :computer => @computer.serialize,
      :tries => @tries,
      :guess_display => @guess_display,
      :wrong_letters => @wrong_letters
    })
  end

  def write_save(save, file_name)
    game_file = File.open(file_name, 'w')
    game_file.write(save)
    game_file.close
  end

  def update_progress
    guess = player.make_guess(@wrong_letters, @guess_display)
    answer = computer.secret_word

    guess_matched_indices = get_guess_matched_indices(guess, answer)

    if incorrect_guess?(guess_matched_indices)
      @tries -= 1
      store_wrong_letters(guess)
    else
      update_display(guess_matched_indices, guess)
    end
  end

  def win?(symbol='_')
    @guess_display.none?(symbol)
  end

  def lose?
    @tries.zero? && !win?
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
