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

  def prompt(initial_msg, pattern, reminder_msg, wrong_letters=nil, correct_letters=nil)
    puts initial_msg

    loop do
      # response = gets.chomp.downcase
      # return response if valid_prompt?(pattern, response)

      # puts reminder_msg

      response = gets.chomp.downcase
      if !valid_prompt?(pattern, response)
        puts reminder_msg
      elsif wrong_letters.include?(response)
        puts 'The letter already exists in wrong letters.'
      elsif correct_letters.include?(response)
        puts 'The letter is correct and already exists.'
      else
        return response
      end
    end
  end

  def make_guess(wrong_letters, correct_letters)
    prompt(
      'Please enter an alphabetical letter to make your guess:',
      /^[a-z]{1}$/,
      "\nPlease enter only one letter from \"a\" to \"z\".",
      wrong_letters,
      correct_letters
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
