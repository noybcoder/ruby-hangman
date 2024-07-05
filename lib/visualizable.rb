# frozen_string_literal: true

require 'rainbow/refinement'

# Visualizable module to handle the visual representation of the Hangman game.
module Visualizable
  # Array of strings representing different hangman states based on the number of tries left.
  HANGMAN_STATES = [
    "__________\n|   _|_\n|  /   \\\n|  \\___/\n|   /|\\\n|  / | \\\n|   / \\\n|  /   \\\n|_________",
    "__________\n|   _|_\n|  /   \\\n|  \\___/\n|   /|\\\n|  / | \\\n|   /\n|  /\n|_________",
    "__________\n|   _|_\n|  /   \\\n|  \\___/\n|   /|\\\n|  / | \\\n|\n|\n|_________",
    "__________\n|   _|_\n|  /   \\\n|  \\___/\n|   /|\n|  / |\n|\n|\n|_________",
    "__________\n|   _|_\n|  /   \\\n|  \\___/\n|    |\n|    |\n|\n|\n|_________",
    "__________\n|   _|_\n|  /   \\\n|  \\___/\n|\n|\n|\n|\n|_________",
    "__________\n|    |\n|\n|\n|\n|\n|\n|\n|_________",
    "__________\n|\n|\n|\n|\n|\n|\n|\n|_________",
    "\n|\n|\n|\n|\n|\n|\n|\n|\n|_________",
    "\n\n\n\n\n\n\n\n\n__________"
  ].freeze # Freeze the array to make it immutable

  # Array of color names used to color the hangman display.
  # Freeze the array to make it immutable
  HANGMAN_COLORS = %w[black blue magenta cyan white aqua silver aliceblue].freeze

  # Public: Selects a random color for the hangman display.
  #
  # Returns a symbol representing the selected color.
  def select_hangman_color
    HANGMAN_COLORS.sample.to_sym # Convert the selected color to a symbol and return it
  end

  # Public: Displays the hangman figure based on the number of tries left.
  #
  # tries - The number of tries left.
  # color - The color used to display the hangman figure.
  # sep - The separator used between each element (default: '').
  #
  # Returns nothing.
  def display_hangman(tries, color, sep = '')
    # Style and print the hangman state based on the number of tries left
    puts style_stats(HANGMAN_STATES[tries], color, sep)
  end

  # Public: Styles the guessed letters with underline.
  #
  # guess - An array of guessed letters.
  #
  # Returns an array of styled letters.
  def style_guess(guess)
    # Underline each letter in the guess array using Rainbow
    guess.map { |letter| Rainbow(letter).underline }
  end

  # Public: Displays the game statistics with colored text.
  #
  # stats_name - The name of the statistic to display.
  # stats - The statistic value to display.
  # color - The color used to display the statistic.
  # sep - The separator used between each element (default: '').
  #
  # Returns nothing.
  def display_stats(stats_name, stats, color, sep = '')
    # Style and print the statistics with the given color and separator
    puts "\n#{stats_name}: #{style_stats(stats, color, sep)}"
  end

  private

  # Private: Styles the statistics with colored text.
  #
  # stats - The statistic value to style (can be an Array or a single value).
  # color - The color used to style the statistic.
  # sep - The separator used between each element if the statistic is an array.
  #
  # Returns the styled statistic.
  def style_stats(stats, color, sep)
    if stats.is_a?(Array) # Check if the statistic is an array
      # Color each element in the array
      formatted_stats = stats.map { |letter| Rainbow(letter).color(color).bright }
      formatted_stats.join(sep) # Join the formatted elements with the separator
    else
      Rainbow(stats).color(color).bright # Color the single statistic value
    end
  end
end
