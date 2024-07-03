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

  def display_hangman(tries)
    puts Rainbow(HANGMAN_STATES[tries]).red
  end

  def style_guess_display(guess)
    guess.map { |letter| Rainbow(letter).underline }
  end

  def display_stats(msg, stats, sep='')
    puts "\n#{msg}: #{style_stats(stats, sep)}"
  end

  def style_stats(stats, sep)
    stats.is_a?(Array) ? stats.join(sep) : stats
  end
end
