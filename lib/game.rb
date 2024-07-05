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
    display_stats('Guess', style_guess(@guess), :darkgreen, ' ') # Display the guess array
    display_hangman(@tries, @hangman_color) # Display the hangman
    display_stats('Wrong letters', @wrong_letters, :red, ', ') # Display the wrong letters
  end

  # Private: Load the game progress from a file if the player chooses to.
  #
  # file_name - The name of the file to load the progress from (default: 'save.txt').
  #
  # Returns nothing.
  def load_progress(file_name = 'save.txt')
    from_json(file_name) if player.load_game == 'y'
  end

  # Private: Load the game state from a JSON file.
  #
  # file_name - The name of the file to load the state from.
  #
  # Returns nothing.
  def from_json(file_name)
    save = read_save(file_name) # Read the save file
    @player = Player.deserialize(save['player']) # Deserialize the player object
    # Deserialize the computer object
    @computer = Computer.deserialize(save['computer'])
    @tries = save['tries'] # Load the number of tries
    @guess = save['guess'] # Load the current guess array
    @wrong_letters = save['wrong_letters'] # Load the wrong letters array
    # Load and convert the hangman color to a symbol
    @hangman_color = save['hangman_color'].to_sym
  end

  # Private: Read the save file and parse the JSON data.
  #
  # file_name - The name of the file to read.
  #
  # Returns the parsed JSON data.
  def read_save(file_name)
    save = File.read(file_name) # Read the file contents
    JSON.parse(save) # Parse the JSON data
  end

  # Private: Save the game progress to a file if the player chooses to.
  #
  # file_name - The name of the file to save the progress to (default: 'save.txt').
  #
  # Returns nothing.
  def save_progress(file_name = 'save.txt')
    # Only save if the game is ongoing and the player opts to save
    return unless !(lose? || win?) && player.save_game == 'y'

    save = to_json # Convert the game state to JSON
    File.write(file_name, save) # Write the JSON data to the file
  end

  # Private: Convert the game state to JSON.
  #
  # Returns the JSON representation of the game state.
  def to_json(*_args)
    JSON.dump({
                player: @player.serialize, # Serialize the player object to JSON
                # Serialize the computer object to JSON
                computer: @computer.serialize,
                tries: @tries, # Include the number of tries
                guess: @guess, # Include the current guess array
                wrong_letters: @wrong_letters, # Include the wrong letters array
                hangman_color: @hangman_color # Include the hangman color
              })
  end

  # Private: Update the game progress based on the player's guess.
  #
  # Returns nothing.
  def update_progress
    guess = player.make_guess(@wrong_letters, @guess) # Get the player's guess
    answer = computer.secret_word # Get the secret word from the computer

    # Find the indices where the guess matches the secret word
    guess_matched_indices = get_guess_matched_indices(guess, answer)

    if incorrect_guess?(guess_matched_indices)
      @tries -= 1 # Decrease the number of tries if the guess is incorrect
      store_wrong_letters(guess) # Store the wrong guess
    else
      # Update the guess display if the guess is correct
      update_display(guess_matched_indices, guess)
    end
  end

  # Private: Check if the player has won the game.
  #
  # symbol - The symbol used for empty spaces in the guess array (default: ' ').
  #
  # Returns true if the player has won, false otherwise.
  def win?(symbol = ' ')
    @guess.none?(symbol) # The player wins as long as the guess array is not empty
  end

  # Private: Check if the player has lost the game.
  #
  # Returns true if the player has lost, false otherwise.
  def lose?
    @tries.zero? && !win? # The player loses if there are no tries left
  end

  # Private: Get the indices where the guess matches the secret word.
  #
  # guess - The player's guess.
  # answer - The secret word.
  #
  # Returns an array of matching indices.
  def get_guess_matched_indices(guess, answer)
    # Find and return the indices where the guess matches the secret word
    answer.chars.each_index.select { |idx| answer[idx] == guess }
  end

  # Private: Check if the guess is incorrect.
  #
  # guess_match_indices - The indices where the guess matches the secret word.
  #
  # Returns true if the guess is incorrect, false otherwise.
  def incorrect_guess?(guess_match_indices)
    # The guess is incorrect if there are no matching indices
    guess_match_indices.empty?
  end

  # Private: Store the wrong guesses.
  #
  # guess - The player's guess.
  #
  # Returns nothing.
  def store_wrong_letters(guess)
    @wrong_letters << guess # Add the wrong guess to the wrong letters array
  end

  # Private: Update the guess display based on the correct guess.
  #
  # guess_match_indices - The indices where the guess matches the secret word.
  # guess - The player's guess.
  #
  # Returns nothing.
  def update_display(guess_match_indices, guess)
    # Update the guess array with the correct guess
    guess_match_indices.each { |idx| @guess[idx] = guess }
  end
end

game = Game.new

game.play
