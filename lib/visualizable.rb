# frozen_string_literal: true

require 'rainbow'

module Visualizable
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
].freeze

  def display_hangman(tries, color, sep = '')
    puts style_stats(HANGMAN_STATES[tries], color, sep)
  end

  def style_guess(guess)
    guess.map { |letter| Rainbow(letter).underline }
  end

  def style_stats(stats, color, sep)
    if stats.is_a?(Array)
      formatted_stats = stats.map { |letter| Rainbow(letter).color(color).bright }
      formatted_stats.join(sep)
    else
      Rainbow(stats).color(color).bright
    end
  end

  def display_stats(stats_name, stats, color, sep = '')
    puts "\n#{stats_name}: #{style_stats(stats, color, sep)}"
  end
end
