# frozen_string_literal: true

require_relative 'player'
require_relative 'computer'
require_relative 'visualizable'
require 'json'

# Game class that represents the Hangman game logic.
class Game
  include Visualizable # Includes the Visualiable module

  # Allows the read access to the instance variables
  attr_reader :player, :computer, :tries, :guess, :wrong_letters

  # Public: Initializes a new Game instance.
  #
  # Returns a new Game object.
  def initialize
    @player = Player.new # Create a new Player instance
    @computer = Computer.new # Create a new Computer instance
    @tries = 10 # Set the number of tries to 10
    @guess = Array.new(computer.secret_word.length, ' ') # Set up a guess display
    @wrong_letters = [] # Set up an empty array to store letters from incorrect guesses
    @hangman_color = select_hangman_color # Set the color of the hangman display
  end

  # Public: Runs the main game loop.
  #
  # Returns nothing.
  def play
    load_progress
    until win? || lose?
      display_game_state
      save_progress
      endgame
    end
  end

  private

  # Private: Displays the message when player wins or loses the game.
  #
  # Returns nothing.
  def endgame
    if win?
      puts "\nYou got it!" # Display the message when the player wins
    elsif lose?
      # Reveal the secret word when the player loses
      puts "\nYou lose! The answer is \"#{computer.secret_word}\"."
    end
  end

  # Private: Displays the current game state.
  #
  # Returns nothing.
  def display_game_state
    display_stats('Tries left', @tries, :yellow) # Display the number of tries left
    update_progress # Update the tries left, the guess display, the hangman display and wrong letters
    display_stats('Guess', style_guess(@guess), :darkgreen, ' ') # Display the guess
    display_hangman(@tries, @hangman_color) # Display the hangman
    display_stats('Wrong letters', @wrong_letters, :red, ', ') # Display the wrong letters
  end

  def load_progress(file_name = 'save.txt')
    from_json(file_name) if player.load_game == 'y'
  end

  def from_json(file_name)
    save = read_save(file_name)
    @player = Player.deserialize(save['player'])
    @computer = Computer.deserialize(save['computer'])
    @tries = save['tries']
    @guess = save['guess']
    @wrong_letters = save['wrong_letters']
    @hangman_color = save['hangman_color'].to_sym
  end

  def read_save(file_name)
    save = File.read(file_name)
    JSON.parse(save)
  end

  def save_progress(file_name = 'save.txt')
    if !(lose? || win?) && player.save_game == 'y'
      save = to_json
      File.write(file_name, save)
    end
  end

  def to_json(*_args)
    JSON.dump({
                player: @player.serialize,
                computer: @computer.serialize,
                tries: @tries,
                guess: @guess,
                wrong_letters: @wrong_letters,
                hangman_color: @hangman_color
              })
  end

  def update_progress
    guess = player.make_guess(@wrong_letters, @guess)
    answer = computer.secret_word

    guess_matched_indices = get_guess_matched_indices(guess, answer)

    if incorrect_guess?(guess_matched_indices)
      @tries -= 1
      store_wrong_letters(guess)
    else
      update_display(guess_matched_indices, guess)
    end
  end

  def win?(symbol = ' ')
    @guess.none?(symbol)
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
    guess_match_indices.each { |idx| @guess[idx] = guess }
  end
end

game = Game.new

game.play
