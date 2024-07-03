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
  ]

  def display_hangman(tries)
    puts HANGMAN_STATES[tries]
  end

  def style_guess_display(guess_display)
    guess_display.map { |letter| Rainbow(letter).underline }
  end

  def display_guess(guess_display)
    puts "\nGuess: #{style_guess_display(guess_display).join(' ')}"
  end

  def display_wrong_letters(wrong_letters)
    puts "\nWrong letters: #{wrong_letters.join(', ')}"
  end
end
