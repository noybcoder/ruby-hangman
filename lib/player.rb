require_relative 'errors'

class Player
  include CustomErrors

  class << self
    attr_accessor :player_count
  end

  PLAYER_LIMIT = 1
  @player_count = 0

  def initialize
    self.class.player_count += 1
    handle_game_violations(PlayerLimitViolation, self.class.player_count, PLAYER_LIMIT)
  end

  def prompt(initial_msg, pattern, reminder_msg)
    puts initial_msg

    loop do
      response = gets.chomp.downcase
      return response if valid_prompt?(pattern, response)

      puts reminder_msg
    end
  end

  def make_guess
    prompt(
      'Please enter an alphabetical letter to make your guess:',
      /^[a-z]{1}$/,
      "\nPlease enter only one letter from \"a\" to \"z\"."
    )
  end

  def save_game
    prompt(
      'Would you like to save your progress (y/n)?',
      /^[yn]{1}$/,
      "\nPlease enter only \"y\" or \"n\"."
    )
  end

  def valid_prompt?(pattern, response)
    pattern.match(response)
  end
end

# player = Player.new
# player.save_game
