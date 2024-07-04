# frozen_string_literal: true

require_relative 'errors'
require 'json'

# Player class that represents a player in the Hangman game.
class Player
  include CustomErrors # Includes the custom error handling module

  # Class-level attribute and method
  class << self
    # Allows the read and write access to the player_count attribute
    attr_accessor :player_count

    # Public: Deserializes a JSON string to recreate a Player instance.
    #
    # serialized_obj - The serialized Player object.
    #
    # Returns a deserialized Player object.
    def deserialize(serialized_obj)
      data = JSON.parse(serialized_obj) # Parses the serialized Player object
      # Decrements the player_count by 1 to offset the increment raised by calling class method
      self.player_count = data['player_count'] - 1
      new # Returns a Player instance with the restored state
    end
  end

  PLAYER_LIMIT = 1 # Set the maximum number of players
  @player_count = 0 # Set the player count to 0

  # Public: Initializes a new Player instance.
  #
  # Returns a new Player object.
  def initialize
    self.class.player_count ||= 0 # Ensures the player count is not nil.
    self.class.player_count += 1 # Increments the player count when the instance is created
    # Checks if the number of players exceeds the limit and handles violations
    handle_game_violations(PlayerLimitViolation, self.class.player_count, PLAYER_LIMIT)
  end

  # Public: Prompts the player to guess a letter.
  #
  # wrong_letters - Letters that do not belong to the answer.
  # correct_letters - Letters that belong to the answer.
  #
  # Returns a single letter that corresponds to the player's guess on the answer.
  def make_guess(wrong_letters, correct_letters)
    prompt(
      "\nPlease enter an alphabetical letter to make your guess:\n",
      /^[a-z]{1}$/, # Expect a single alphabetical letter
      "\nPlease enter only one letter from \"a\" to \"z\".\n",
      wrong_letters,
      correct_letters
    )
  end

  # Public: Asks the player if they want to load the most recent game save.
  #
  # Returns a single letter that corresponds to the player's response on the prompt.
  def load_game
    prompt(
      "\nWould you like to load your previous progress (y/n)?\n",
      /^[yn]{1}$/, # Expect 'y' or 'n'
      "\nPlease enter only \"y\" or \"n\".\n"
    )
  end

  # Public: Asks the player if they want to save the current game status.
  #
  # Returns a single letter that corresponds to the player's response on the prompt.
  def save_game
    prompt(
      "\nSave current progress (y/n)?\n",
      /^[yn]{1}$/, # Expect 'y' or 'n'
      "\nPlease enter only \"y\" or \"n\".\n"
    )
  end

  # Public: Serializes the player state to a JSON string.
  #
  # Returns a JSON string representing the serialized player state.
  def serialize
    JSON.dump({
                player_count: self.class.player_count
              })
  end

  private

  # Private: Prompts the player for input and validates it
  #
  # initial_msg - The initial message that prompts the player for input.
  # pattern - The word pattern used to validate player input.
  # reminder_msg - The message that prompts the player when the input is invalid.
  # wrong_letters - Letters that do not belong to the answer (default: nil).
  # correct_letters - Letters that belong to the answer (default: nil).
  #
  # Returns a valid response from the player.
  def prompt(initial_msg, pattern, reminder_msg, wrong_letters = nil, correct_letters = nil)
    puts initial_msg

    loop do
      response = gets.chomp.downcase
      if !valid_prompt?(pattern, response)
        puts reminder_msg
      elsif wrong_letters&.include?(response)
        puts "\nThe letter is already part of the wrong letters. Please try again."
      elsif correct_letters&.include?(response)
        puts "\nThe letter is already in the guess. Please try a different letter."
      else
        return response
      end
    end
  end

  # Private: Validates the user input against a pattern
  #
  # pattern - The word pattern used to validate player input.
  # response - The player's response to the prompt.
  #
  # Returns true if the input is valid, otherwise false.
  def valid_prompt?(pattern, response)
    pattern.match(response)
  end
end
