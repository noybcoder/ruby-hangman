# frozen_string_literal: true

require_relative 'errors'
require 'json'

# Computer class that represents the npc in the Hangman game.
class Computer
  include CustomErrors # Includes the custom error handling module

  # Class-level attribute and method
  class << self
    # Allows the read and write access to the computer_count attribute
    attr_accessor :computer_count

    # Public: Deserializes a JSON string to recreate a Computer instance.
    #
    # serialized_obj - The serialized Computer object.
    #
    # Returns a deserialized Comptuer object.
    def deserialize(serialized_obj)
      data = JSON.parse(serialized_obj) # Parses the serialized Computer object
      # Decrements the player_count by 1 to offset the increment raised by calling class method
      self.computer_count = data['computer_count'] - 1
      computer = new # Creates a new Computer instance
      # Sets the @secret_word instance variable to the value stored in the serialized data.
      computer.instance_variable_set(:@secret_word, data['secret_word'])
      computer # Returns a new Computer instance with the stored state
    end
  end

  COMPUTER_LIMIT = 1 # Set the maximum number of players
  @computer_count = 0 # Set the player count to 0

  attr_reader :secret_word # Allows read access to the secret_word attribute

  # Public: Initializes a new Computer instance.
  #
  # file - The file containing the list of words (default: 'google-10000-english-no-swears.txt').
  # sep - The separator used to split the words in the file (default: "\n").
  #
  # Returns a new Computer object.
  def initialize(file = 'google-10000-english-no-swears.txt', sep = "\n")
    dictionary = read_dictionary(file, sep) # Load the dictionary from the input file
    @secret_word = select_random_word(dictionary) # Choose a random word from the dictionary
    self.class.computer_count ||= 0 # Ensures the computer count is not nil.
    self.class.computer_count += 1 # Increments the computer count when the instance is created
    # Checks if the number of players exceeds the limit and handles violations
    handle_game_violations(ComputerLimitViolation, self.class.computer_count, COMPUTER_LIMIT)
  end

  # Public: Serializes the computer state to a JSON string.
  #
  # Returns a JSON string representing the serialized computer state.
  def serialize
    JSON.dump({
                computer_count: self.class.computer_count,
                secret_word: secret_word
              })
  end

  private

  # Private: Reads the dictionary file and splits it into an array of words
  #
  # file - The file containing the list of words.
  # sep - The separator used to split the words in the file.
  #
  # Returns an array of words from the file.
  def read_dictionary(file, sep)
    File.read(file).split(sep)
  end

  # Private: Filters the dictionary to select words of a desired length
  #
  # dictionary - The array of words to filter.
  #
  # Returns an array of words with lengths between 5 and 12 characters.
  def filter_words(dictionary)
    dictionary.select { |word| word.length.between?(5, 12) }
  end

  # Private: Selects a random word from the filtered dictionary
  #
  # dictionary - The array of words to select from.
  #
  # Returns a randomly selected word.
  def select_random_word(dictionary)
    filter_words(dictionary).sample
  end
end
