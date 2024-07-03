# frozen_string_literal: true

require_relative 'errors'
require 'json'

class Computer
  include CustomErrors

  class << self
    attr_accessor :computer_count
  end

  COMPUTER_LIMIT = 1
  @computer_count = 0

  attr_reader :secret_word

  def initialize(file = 'google-10000-english-no-swears.txt', sep = "\n", from = 5, to = 12)
    dictionary = read_dictionary(file, sep)
    @secret_word = select_random_word(dictionary, from, to)
    self.class.computer_count ||= 0
    self.class.computer_count += 1
    handle_game_violations(ComputerLimitViolation, self.class.computer_count, COMPUTER_LIMIT)
  end

  def read_dictionary(file, sep)
    File.read(file).split(sep)
  end

  def filter_words(dictionary, from, to)
    dictionary.select { |word| word.length.between?(from, to) }
  end

  def select_random_word(dictionary, from, to)
    filter_words(dictionary, from, to).sample
  end

  def serialize
    JSON.dump({
                computer_count: self.class.computer_count,
                secret_word: secret_word
              })
  end

  def self.deserialize(serialized_obj)
    data = JSON.parse(serialized_obj)
    self.computer_count = data['computer_count'] - 1
    computer = new
    computer.instance_variable_set(:@secret_word, data['secret_word'])
    computer
  end
end
