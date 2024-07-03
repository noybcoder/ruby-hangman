require_relative 'errors'
require 'json'

class Player
  include CustomErrors

  class << self
    attr_accessor :player_count, :instantiated
  end

  PLAYER_LIMIT = 1
  @player_count = 0

  def initialize
    self.class.player_count ||= 0
    self.class.player_count += 1
    handle_game_violations(PlayerLimitViolation, self.class.player_count, PLAYER_LIMIT)
  end

  def prompt(initial_msg, pattern, reminder_msg, wrong_letters=nil, correct_letters=nil)
    puts initial_msg

    loop do
      response = gets.chomp.downcase
      if !valid_prompt?(pattern, response)
        puts reminder_msg
      elsif wrong_letters&.include?(response)
        puts '\nThe letter already exists in wrong letters.'
      elsif correct_letters&.include?(response)
        puts '\nThe letter is correct and already exists.'
      else
        return response
      end
    end
  end

  def make_guess(wrong_letters, correct_letters)
    prompt(
      "Please enter an alphabetical letter to make your guess:\n",
      /^[a-z]{1}$/,
      "Please enter only one letter from \"a\" to \"z\".\n",
      wrong_letters,
      correct_letters
    )
  end

  def load_game
    prompt(
      "Would you like to load your previous progress (y/n)?\n",
      /^[yn]{1}$/,
      "Please enter only \"y\" or \"n\".\n"
    )
  end

  def save_game
    prompt(
      "Would you like to save your progress (y/n)?\n",
      /^[yn]{1}$/,
      "Please enter only \"y\" or \"n\".\n"
    )
  end

  def valid_prompt?(pattern, response)
    pattern.match(response)
  end

  def serialize
    JSON.dump({
      :player_count => self.class.player_count,
    })
  end

  def self.deserialize(serialized_obj)
    data = JSON.load(serialized_obj)
    self.player_count = data['player_count'] - 1
    new
  end
end
